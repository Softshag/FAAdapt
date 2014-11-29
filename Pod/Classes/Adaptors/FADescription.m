//
//  FADescription.m
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 05/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FADescription.h"
#import "FAAdaptPropertyFinder.h"

NSString *kErrorDomain = @"com.adapt.object";


@implementation FADescription

@synthesize destinationClass = _destinationClass;
@synthesize property = _property;

+ (instancetype)descriptionWithProperty:(NSString *)property {
    id<FADescription> t = [self new];
    t.property = property;
    
    return t;
}

+ (instancetype)descriptionWithProperty:(NSString *)property class:(Class)destClass {
    id<FADescription> t = [self new];
    
    if (![FAAdaptPropertyFinder hasProperty:property onClass:destClass]) {
        @throw [NSException exceptionWithName:@"Property" reason:
                [NSString stringWithFormat:@"Keypath %@ does not exist on path",property] userInfo:nil];
       
    }
    
    Class class = [FAAdaptPropertyFinder propertyType:property onClass:destClass];
    
    t.property = property;
    t.destinationClass = class;
    
    return t;
}


- (id)mapValue:(id)value error:(NSError *__autoreleasing *)error {
    return nil;
}

- (FADescription *(^)(id (^)(Class class, id value)))create {
    return ^(id (^creator)(Class class, id value)) {
        _creator = creator;
        return self;
    };
}

- (FADescription * (^)(NSString *property))map {
    return ^(NSString *property) {
        self.property = property;
        return self;
    };
}


- (FADescription *(^)(BOOL required))required {
    return ^(BOOL required) {
        _isRequired = required;
        return self;
    };
}

@end
