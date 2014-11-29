//
//  FAEntityDescription.m
//  FAAdaptExample
//
//  Created by Rasmus Kildevaeld on 29/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FAEntityDescription.h"
#import <CoreData/CoreData.h>
#import "NSArray+Functions.h"
#import "FAArrayDescription.h"
#import "FAPropertyDescription.h"

@import CoreData;

FAEntityDescription *AdaptEntity(Class klass, NSDictionary *description) {
    FAEntityDescription *desc = [FAEntityDescription new];
    
    desc.destinationClass = klass;
    [desc addDescriptionDictionary:description];
    
    return desc;
}

@interface FAEntityDescription ()

- (NSManagedObjectID *)loadManagedObject:(NSEntityDescription *)desc withPredicate:(NSPredicate *)value;

@end

@implementation FAEntityDescription

- (void)addDescription:(id<FADescription>)descriptor forProperty:(NSString *)property {
    
    if ([descriptor isKindOfClass:FAEntityDescription.class]) {
        FAEntityDescription *desc = (FAEntityDescription *)descriptor;
        
        desc.managedObjectContext = self.managedObjectContext;
    } else if ([descriptor isKindOfClass:FAArrayDescription.class]) {
        
        FAArrayDescription *desc = (FAArrayDescription *)descriptor;
        if ([desc.descriptor isKindOfClass:FAEntityDescription.class]) {
            [(FAEntityDescription *)desc.descriptor setManagedObjectContext:self.managedObjectContext];
        }
    }
    
    [super addDescription:descriptor forProperty:property];
}

- (BOOL)setValue:(id)value withDescriptor:(id<FADescription>)descriptor property:(NSString *)property onInstance:(id)instance error:(NSError **)error {
    
    NSError *innerError;
    
    id newValue = [descriptor mapValue:value error:&innerError];
    
    if (innerError != nil) {
        *error = innerError;
        return false;
    }
    
    [_managedObjectContext performBlockAndWait:^{
        NSManagedObject *object = [_managedObjectContext objectRegisteredForID:instance];
        
        // It's and ObjectID
        if ([newValue isKindOfClass:NSManagedObjectID.class]) {
            id tmp = [_managedObjectContext objectWithID:newValue];
            [object setValue:tmp forKey:descriptor.property];
            // It's an array or set
        } else if ([newValue isKindOfClass:NSArray.class] || [newValue isKindOfClass:NSSet.class]) {
            NSArray *array = [newValue isKindOfClass:NSSet.class] ? [(NSSet *)newValue allObjects] : newValue;
            id o = array.firstObject;
            if ([o isKindOfClass:NSManagedObjectID.class]) {
                NSArray *val = array.map(^(id vv) {
                    return [_managedObjectContext objectRegisteredForID:vv];
                });
                [object setValue:[NSSet setWithArray:val] forKey:descriptor.property];
            } else {
                [object setValue:newValue forKeyPath:descriptor.property];
            }
            
        } else {
            [object setValue:newValue forKeyPath:descriptor.property];
        }
    }];
    
    
    return true;
}



- (id)createInstance:(NSDictionary *)value {
    if (_creator != nil) {
        return _creator(self.destinationClass, value);
    }
    
    NSString *entityName = self.entityName;
    
    if (entityName == nil)
        entityName = NSStringFromClass(self.destinationClass);
    
    NSEntityDescription *description = [NSEntityDescription entityForName:entityName
                                                   inManagedObjectContext:_managedObjectContext];
    
    __block NSManagedObjectID *object;
    
    // Get PrimaryKeys
    NSArray *primaryKeys = _descriptors.allKeys.map(^(NSString *key) {
        id<FADescription> value = _descriptors[key];
        
        if ([value isKindOfClass:FAPropertyDescription.class]) {
            FAPropertyDescription *prop = (FAPropertyDescription *)value;
            
            if (prop.isPrimaryKey)
                return key;
        }
        return (NSString *)nil;
    }).map(^(NSString *primaryKey) {
        id val;
        if ([value isKindOfClass:NSDictionary.class]) {
            val = [value objectForKey:primaryKey];
        } else {
            val = value;
        }
        
        if (val == nil || [value isKindOfClass:NSNull.class])
            return (NSPredicate*)nil;
        
        FAPropertyDescription *desc = _descriptors[primaryKey];
        return [NSPredicate predicateWithFormat:@"%K = %@",desc.property, val];
    });
    
    if (primaryKeys.count > 0) {
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:primaryKeys];
        
        object = [self loadManagedObject:description withPredicate:predicate];
        
        if (object == nil && self.shouldCreateOnNotFound) {
            if (_creator != nil) {
                object = _creator(self.destinationClass, value);
            } else {
                [self.managedObjectContext performBlockAndWait:^{
                    NSManagedObject *o = [[self.destinationClass alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
                    object = o.objectID;
                }];
                
            }
        }
        
        return object;
    }
    
    if (value == nil || [value isKindOfClass:NSNull.class])
        return nil;
    
    [self.managedObjectContext performBlockAndWait:^{
        NSManagedObject *o = [[self.destinationClass alloc] initWithEntity:description insertIntoManagedObjectContext:self.managedObjectContext];
        object = o.objectID;
    }];
    
    return object;
}

- (NSManagedObjectID *)loadManagedObject:(NSEntityDescription *)desc withPredicate:(NSPredicate *)predicate {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.resultType = NSManagedObjectIDResultType;
    
    [request setEntity:desc];
    [request setFetchLimit:1];
    [request setPredicate:predicate];
    
    __block NSManagedObjectID *object;
    
    [self.managedObjectContext performBlockAndWait:^{
        NSError *error;
        NSArray *array = [_managedObjectContext executeFetchRequest:request error:&error];
        
        NSManagedObjectID *o = array.first;
        if (o != nil)
            object = o;
    }];
    
    
    return object;
}

// Recursively set managedobjectcontext on all FAManagedObjectDescriptors.
- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    _managedObjectContext = managedObjectContext;
    
    _descriptors.allValues.each(^(id value, BOOL *stop) {
        
        if ([value isKindOfClass:FAEntityDescription.class]) {
            FAEntityDescription *desc = (FAEntityDescription *)value;
            desc.managedObjectContext = _managedObjectContext;
            
        } else if ([value isKindOfClass:FAArrayDescription.class]) {
            
            FAArrayDescription *desc = (FAArrayDescription *)value;
            if ([desc.descriptor isKindOfClass:FAEntityDescription.class]) {
                [(FAEntityDescription *)desc.descriptor setManagedObjectContext:_managedObjectContext];
            }
        }
    });
}

- (FAEntityDescription *(^)(BOOL create))createOnNotFound {
    return ^(BOOL create) {
        _shouldCreateOnNotFound = create;
        return self;
    };
}

@end
