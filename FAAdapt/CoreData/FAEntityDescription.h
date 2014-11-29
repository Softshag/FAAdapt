//
//  FAEntityDescription.h
//  FAAdaptExample
//
//  Created by Rasmus Kildevaeld on 29/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FAObjectDescription.h"
#import "FAPropertyDescription+CoreData.h"

@class FAEntityDescription, NSManagedObjectContext;

extern FAEntityDescription *AdaptEntity();

@interface FAEntityDescription : FAObjectDescription

@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSString *primaryKey;
@property (nonatomic, readonly) BOOL shouldCreateOnNotFound;
@property (nonatomic, copy, readonly) FAEntityDescription *(^createOnNotFound)(BOOL create);

@end
