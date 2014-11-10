//
//  FAObjectDescription.m
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 05/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FAObjectDescription.h"
#import "FAPropertyDescription.h"
#import "FAArrayDescription.h"
#import "FAAdaptPropertyFinder.h"

#import "FAAdapt.h"


@interface FAObjectDescription ()



- (BOOL)setValue:(id)value withPropertyMapping:(NSString *)map property:(NSString*)property onInstance:(id)instance error:(NSError **)error;

@end

@implementation FAObjectDescription


+ (instancetype)descriptionWith:(Class)klass dictionary:(NSDictionary *)dictionary {
    FAObjectDescription *i =  [self descriptionWith:klass];
    [i addDescriptionDictionary:dictionary];
    
    return i;
}

+ (instancetype)descriptionWith:(Class)klass {
    FAObjectDescription *i = [FAObjectDescription new];
    i.destinationClass = klass;
    
    return i;
}

- (id)init {
    if ((self = [super init])) {
        _descriptors = [NSMutableDictionary new];
        self.strict = false;
    }
    
    return self;
}

- (void)addDescription:(id<FADescription>)descriptor forProperty:(NSString *)property {
    
    // Add default destination property for the descriptor
    if (descriptor.property == nil) {
        descriptor.property = property;
    }
    
    // If no destination class is set infere it.
    if (descriptor.destinationClass == nil) {
        // Throw an exception if the property does'nt exists on the the target type
        if (![FAAdaptPropertyFinder hasProperty:descriptor.property onClass:self.destinationClass]) {
            @throw [NSException exceptionWithName:@"Property"
                                           reason:[NSString stringWithFormat:@"Property: %@ of wrong type",property]
                                         userInfo:nil];
        }
        Class destClass = [FAAdaptPropertyFinder propertyType:descriptor.property onClass:self.destinationClass];
        
        descriptor.destinationClass =  destClass;
    }
    
    _descriptors[property] = descriptor;
}

- (void)addDescriptionDictionary:(NSDictionary *)dictionary {
    id<FADescription> descriptor;
    
    for (NSString *key in dictionary.allKeys) {
        id value = dictionary[key];

        if ([value isKindOfClass:NSString.class]) {
            descriptor = [FAPropertyDescription descriptionWithProperty:value class:self.destinationClass];
        
        } else if ([value conformsToProtocol:@protocol(FADescription)]) {
            descriptor = value;
        
        } else if ([value isKindOfClass:NSArray.class]) {
            
        }
        
        [self addDescription:descriptor forProperty:key];
    }
    
}

- (id<FADescription>)getDescription:(NSString *)property {
    return _descriptors[property];
}

- (id)mapValue:(id )_dictionary error:(NSError **)error {
    
    id instance = [self createInstance:_dictionary];
    
    if (instance == nil) {
        return nil;
    }
    
    NSDictionary *dictionary;
    
    if ([_dictionary isKindOfClass:NSDictionary.class]) {
        dictionary = (NSDictionary *)_dictionary;
    } else {
        if (_descriptors.count > 1 || _descriptors.allKeys.count == 0) {
            *error = [NSError errorWithDomain:kFAAdaptErrorDomain code:DESCRIPTOR_OVERFLOW userInfo:nil];
            return nil;
        }
        
        id<FADescription> desc = _descriptors[_descriptors.allKeys[0]];
    
        [self setValue:_dictionary withDescriptor:desc property:nil onInstance:instance error:error];
        
        return instance;
    }
    
    
    for (id property in dictionary.allKeys) {
    
            
        id value = [dictionary valueForKeyPath:property];
            
        id<FADescription> descriptor = [self getDescription:property];
        NSError *innerError;
            
        // Does a descriptor exists for this property
        if (descriptor == nil) {
                
            // Should we try yo map any way
            if (self.shouldMapUndefinedProperties) {
                [self setValue:value withPropertyMapping:property property:property onInstance:instance error:&innerError];
            } else {
                continue;
            }
               
        } else {
            
            [self setValue:value withDescriptor:descriptor property:property onInstance:instance error:&innerError];
        
        }
            
        if (innerError != nil) {
            if (error != nil)
                *error = innerError;
            break;
        }
        
    }
    
    return instance;
}


- (BOOL)setValue:(id)value withDescriptor:(id<FADescription>)descriptor property:(NSString*)property onInstance:(id)instance error:(NSError **)error {
    
    NSError *innerError;
    
    id newValue = [descriptor mapValue:value error:&innerError];

    if (innerError != nil) {
        *error = innerError;
        return false;
    }
    
    if (newValue == nil && descriptor.isRequired) {
        *error = [NSError errorWithDomain:kFAAdaptErrorDomain code:REQUIRED userInfo:@{@"field":[descriptor.property copy]}];
        return false;
    }
    
    
    [instance setValue:newValue forKeyPath:descriptor.property];
    
    return true;
}

- (BOOL)setValue:(id)value withPropertyMapping:(NSString *)map property:(NSString*)property onInstance:(id)instance error:(NSError **)error {
    
    if ([FAAdaptPropertyFinder hasProperty:map onClass:self.destinationClass]) {
        
        FAPropertyDescription *desc = [FAPropertyDescription descriptionWithProperty:property class:self.destinationClass];
        
        [self addDescription:desc forProperty:property]; // Cache
        
        return [self setValue:value withDescriptor:desc property:property onInstance:instance error:error];
    }
    
    return false;
}

- (id)createInstance:(NSDictionary *)value {
    if (_creator != nil) {
        return _creator(self.destinationClass, value);
    }
    return [self.destinationClass new];
}


@end
