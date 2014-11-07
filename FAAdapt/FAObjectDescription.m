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


@interface FAObjectDescription ()

- (BOOL)setValue:(id)value withDescriptor:(id<FADescription>)descriptor property:(NSString*)property onInstance:(id)instance;

- (BOOL)setValue:(id)value withPropertyMapping:(NSString *)map property:(NSString*)property onInstance:(id)instance;

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
    id<FADescription> d;
    
    for (NSString *key in dictionary.allKeys) {
        id value = dictionary[key];

        if ([value isKindOfClass:NSString.class]) {
            d = [FAPropertyDescription descriptionWithProperty:value class:self.destinationClass];
        
        } else if ([value conformsToProtocol:@protocol(FADescription)]) {
            d = value;
        
        } else if ([value isKindOfClass:NSArray.class]) {
            
        }
        
        [self addDescription:d forProperty:key];
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
            *error = [NSError errorWithDomain:kErrorDomain code:1 userInfo:nil];
            return nil;
        }
        
        id<FADescription> desc = _descriptors[_descriptors.allKeys[0]];
    
        [self setValue:_dictionary withDescriptor:desc property:nil onInstance:instance];
        
        return instance;
    }
    
    
    for (id property in dictionary.allKeys) {
        @autoreleasepool {
            
            id value = dictionary[property];
            id<FADescription> descriptor = [self getDescription:property];
            
            // Does a descriptor exists for this property
            if (descriptor == nil) {
                // Should we try yo map any way
                if (self.shouldMapUndefinedProperties) {
                    
                    [self setValue:value withPropertyMapping:property property:property onInstance:instance];
                } else {
                    continue;
                }
                
            } else {
                [self setValue:value withDescriptor:descriptor property:property onInstance:instance];
            }
        }
        
    }
    
    return instance;
}


- (BOOL)setValue:(id)value withDescriptor:(id<FADescription>)descriptor property:(NSString*)property onInstance:(id)instance {
    
    NSError *error;
    
    id newValue = [descriptor mapValue:value error:&error];

    if (error != nil) {
        return false;
    }
    
    
    [instance setValue:newValue forKeyPath:descriptor.property];
    
    return true;
}

- (BOOL)setValue:(id)value withPropertyMapping:(NSString *)map property:(NSString*)property onInstance:(id)instance {
    
    if ([FAAdaptPropertyFinder hasProperty:map onClass:self.destinationClass]) {
        
        FAPropertyDescription *desc = [FAPropertyDescription descriptionWithProperty:property class:self.destinationClass];
        
        [self addDescription:desc forProperty:property]; // Cache
        
        return [self setValue:value withDescriptor:desc property:property onInstance:instance];
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
