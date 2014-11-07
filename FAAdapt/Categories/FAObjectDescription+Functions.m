//
//  FAObjectDescription+Functions.m
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 07/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FAObjectDescription+Functions.h"
#import "FAArrayDescription.h"
#import "FAPropertyDescription.h"
#import "FAAdaptPropertyFinder.h"

@implementation FAObjectDescription (Functions)

/*- (FAPropertyDescription * (^)(NSString *property))map {
    return ^(NSString *property) {
        self.property = property;
        return self;
    };
}*/

- (FAPropertyDescription * (^)(NSString *property, NSString *destProp))prop {
    return ^(NSString *property, NSString *destProp) {
        FAPropertyDescription *desc = [FAPropertyDescription descriptionWithProperty:destProp];
        [self addDescription:desc forProperty:property];
        return desc;
    };
}

- (FAObjectDescription * (^)(NSString *property, NSString *destProp, NSDictionary *dictionary))object {
    
    return ^(NSString *property, NSString *destProp, NSDictionary *dictionary) {
        
        if (destProp == nil) {
            destProp = property;
        }
        
        if (![FAAdaptPropertyFinder hasProperty:destProp onClass:self.destinationClass]) {
            @throw [NSException exceptionWithName:@"Property"
                                           reason:[NSString stringWithFormat:@"Property: %@ of wrong type",property]
                                         userInfo:nil];
        }
        
        Class destClass = [FAAdaptPropertyFinder propertyType:destProp onClass:self.destinationClass];
        
        FAObjectDescription *desc;
        
        if (dictionary == nil) {
            desc = [FAObjectDescription descriptionWith:destClass];
        } else {
            desc = [FAObjectDescription descriptionWith:destClass dictionary:dictionary];
        }
        
        desc.property = destProp;
        
        [self addDescription:desc forProperty:property];
        
        return desc;
    };
}

- (FAArrayDescription * (^)(NSString *property, NSString *destProp, id<FADescription> description))array {
    return ^(NSString *property, NSString *destProp, id<FADescription> description) {
        FAArrayDescription *desc = [FAArrayDescription descriptionWithDescription:description];
        [self addDescription:desc forProperty:property];
        return desc;
    };
}


@end
