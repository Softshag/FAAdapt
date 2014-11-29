//
//  FAArrayDescription.h
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 05/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FADescription.h"

@interface FAArrayDescription : FADescription

@property (nonatomic, strong, readonly) id<FADescription> descriptor;

+ (instancetype)descriptionWithDescription:(id<FADescription>)descriptor;


@end
