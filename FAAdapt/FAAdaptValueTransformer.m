//
//  FAMapperValueTransformer.m
//  FAMapper
//
//  Created by Rasmus Kildevaeld on 23/11/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import "FAAdaptValueTransformer.h"
#import "RKValueTransformers.h"

@implementation FAAdaptValueTransformer

+ (id)transformValue:(id)value toValueOfType:(Class)klass {
    id newValue;
    if ([value isKindOfClass:[NSNull class]] || ([value isKindOfClass:[NSString class]] && [value isEqualToString:@""]))
        return nil;
    
    if (klass == nil || [value isKindOfClass:klass]) {
        return value;
    }
    NSError *err;
    if ([NSNumber class] == klass) {
        NSNumber *output;
        if ([[RKValueTransformer numberToStringValueTransformer] transformValue:value toValue:&output ofClass:klass error:&err]) {
            return output;
        }
    } else if ([NSDate class] == klass) {
        NSDate *output;
        if ([value isKindOfClass:[NSNumber class]]) {
            newValue = value;
        } else if ([value isKindOfClass:[NSString class]]) {
            if ((int)[value doubleValue] == 0)
                return nil;
            newValue = @([value doubleValue]);
        }
        if ([[RKValueTransformer timeIntervalSince1970ToDateValueTransformer] transformValue:newValue toValue:&output ofClass:klass error:&err]) {
            return output;
        }
    } else if ([NSURL class] == klass) {
        NSURL *output;
        if ([[RKValueTransformer stringToURLValueTransformer] transformValue:value toValue:&output ofClass:klass error:&err]) {
            return output;
        }
    } else if ([NSString class] == klass) {
        NSString *output;
        if ([[RKValueTransformer stringValueTransformer] transformValue:value toValue:&output ofClass:klass error:&err]) {
            return output;
        }
    } else if ([NSSet class] == klass) {
        NSSet *output;
        if ([[RKValueTransformer arrayToSetValueTransformer] transformValue:value toValue:&output ofClass:klass error:&err]) {
            return output;
        }
    } else if ([NSOrderedSet class] == klass) {
        NSOrderedSet *output;
        if ([[RKValueTransformer arrayToOrderedSetValueTransformer] transformValue:value toValue:&output ofClass:klass error:&err]) {
            return output;
        }
    } else if (NSArray.class == klass) {
        NSArray *output;
        if ([[RKValueTransformer arrayToOrderedSetValueTransformer] transformValue:value toValue:&output ofClass:klass error:&err]) {
            return output;
        }
    }
    
    return nil;
    
    
}

@end
