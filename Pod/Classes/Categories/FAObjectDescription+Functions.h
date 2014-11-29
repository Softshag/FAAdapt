//
//  FAObjectDescription+Functions.h
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 07/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FAObjectDescription.h"

@class FAPropertyDescription;
@class FAArrayDescription;
@class FAObjectDescription;

@interface FAObjectDescription (Functions)

@property (nonatomic, copy, readonly) FAPropertyDescription * (^prop)(NSString *property, NSString *destProp);
@property (nonatomic, copy, readonly) FAObjectDescription * (^object)(NSString *property, NSString *destProp, NSDictionary *dictionary);
@property (nonatomic, copy, readonly) FAArrayDescription * (^array)(NSString *property, NSString *destProp,id<FADescription> description);


@end
