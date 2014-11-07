//
//  FAPropertyDescription.h
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 05/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FADescription.h"

@interface FAPropertyDescription : FADescription {
    id (^_converter)(id value, NSError **error);
}

@property (nonatomic, copy, readonly) FAPropertyDescription * (^convert)(id (^converter)(id value, NSError **error));

@end
