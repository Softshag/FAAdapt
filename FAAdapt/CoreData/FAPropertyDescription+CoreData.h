//
//  FAPropertyDescription+CoreData.h
//  FAAdaptExample
//
//  Created by Rasmus Kildevaeld on 29/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FAPropertyDescription.h"

@interface FAPropertyDescription (CoreData)

@property (nonatomic, copy, readonly) FAPropertyDescription *(^primaryKey)(BOOL primary);
@property (nonatomic, readonly) BOOL isPrimaryKey;

@end
