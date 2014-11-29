//
//  FAObjectDescription.h
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 05/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FADescription.h"

// For Loading an object
typedef NSManagedObjectID *(^loadModelBlock)(Class klass, NSString *key, NSString *value);
// For Setting a values on an object
typedef BOOL (^setValueBlock)(NSManagedObjectID *object, NSString *key, id value);
// For instantiating a new object
typedef id (^createObjectBlock)(Class class, id value);


@interface FAObjectDescription : FADescription {
    NSMutableDictionary *_descriptors;
}

@property (nonatomic, getter = isStrict) BOOL strict;

/** Should map undefined properties */
@property (nonatomic, getter = shouldMapUndefinedProperties) BOOL mapUndefinedProperties;
@property (nonatomic, copy, readonly) FAObjectDescription * (^mapUndefined)(BOOL map);


+ (instancetype)descriptionWith:(Class)klass dictionary:(NSDictionary *)dictionary;

+ (instancetype)descriptionWith:(Class)klass;

- (void)addDescription:(id<FADescription>)descriptor forProperty:(NSString *)property;

- (void)addDescriptionDictionary:(NSDictionary *)dictionary;

- (id<FADescription>)getDescription:(NSString *)property;

- (id)createInstance:(NSDictionary *)value;

- (BOOL)setValue:(id)value withDescriptor:(id<FADescription>)descriptor property:(NSString*)property onInstance:(id)instance error:(NSError **)error;

@end
