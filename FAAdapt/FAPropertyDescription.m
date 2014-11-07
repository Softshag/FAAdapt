//
//  FAPropertyDescription.m
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 05/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FAPropertyDescription.h"
#import "FAAdaptValueTransformer.h"


@implementation FAPropertyDescription


- (id)mapValue:(id)value error:(NSError **)error {
    id newValue = value;
    
    if ([value isKindOfClass:NSNumber.class] && strcmp([newValue objCType], @encode(BOOL)) == 0) {
        return newValue;
    }
    
    if (_converter != nil) {
        NSError *innerError;
        newValue = _converter(value, &innerError);
        
        // Should return the converters error
        if (innerError != nil) {
            *error = innerError;
            return nil;
        }
        
    }
    
    // Should return if the destination class isn't set.
    if (self.destinationClass == nil) {
        *error = [NSError errorWithDomain:kErrorDomain code:1 userInfo:nil];
        return nil;
    }
    
    if ([newValue isKindOfClass:self.destinationClass]) {
        return newValue;
    } else {
        newValue = [FAAdaptValueTransformer transformValue:value toValueOfType:self.destinationClass];
        return newValue;
    }
}

- (FAPropertyDescription *(^)(id (^)(id value, NSError **error)))convert {
    return ^(id (^converter)(id value, NSError **error)) {
        _converter = converter;
        return self;
    };
}


@end
