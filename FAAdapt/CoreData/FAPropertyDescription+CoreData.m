//
//  FAPropertyDescription+CoreData.m
//  FAAdaptExample
//
//  Created by Rasmus Kildevaeld on 29/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FAPropertyDescription+CoreData.h"

@implementation FAPropertyDescription (CoreData)

@dynamic primaryKey, isPrimaryKey;

- (FAPropertyDescription *(^)(BOOL primaryKey))primaryKey {
    return ^(BOOL primaryKey) {
        objc_setAssociatedObject(self, "primary_key", @(primaryKey), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return self;
    };
}

- (BOOL)isPrimaryKey {
    NSNumber *primaryKey = objc_getAssociatedObject(self, "primary_key");
    if (primaryKey == nil)
        primaryKey = @(NO);
    
    return primaryKey.boolValue;
}

@end
