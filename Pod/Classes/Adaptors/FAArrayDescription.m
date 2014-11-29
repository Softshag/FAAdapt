//
//  FAArrayDescription.m
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 05/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FAArrayDescription.h"
#import "FAAdaptValueTransformer.h"

@interface FAArrayDescription ()

@property (nonatomic, strong, readwrite) id<FADescription> descriptor;


@end

@implementation FAArrayDescription

@synthesize descriptor = _descriptor;
@synthesize destinationClass = _destinationClass;

+ (instancetype)descriptionWithDescription:(id<FADescription>)descriptor {
    FAArrayDescription *desc = [self new];
    desc.descriptor = descriptor;
    
    return desc;
}


- (id)mapValue:(id)value error:(NSError *__autoreleasing *)error {
    if (![value conformsToProtocol:@protocol(NSFastEnumeration)])
        return nil;
    
    id<NSFastEnumeration> e = (id<NSFastEnumeration>)value;
    
    id result;
    
    if (self.descriptor != nil) {
    
        NSMutableArray *tmp = [NSMutableArray new];
        
        for (id child in e) {
            id c = [self.descriptor mapValue:child error:nil];
            
            if (c != nil) {
                [tmp addObject:c];
            }
        }
        
        result = tmp;
        
    } else {
        result = value;
    }
    
    id output = [FAAdaptValueTransformer transformValue:result toValueOfType:self.destinationClass];
    
    return output;
    
}

- (Class)destinationClass {
    if (!_destinationClass) {
        _destinationClass = NSArray.class;
    }
    return _destinationClass;
}

@end
