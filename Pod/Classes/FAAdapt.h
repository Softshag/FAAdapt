//
//  FAObjectMap.h
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 05/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>

// Descriptors
#import "FAObjectDescription.h"
#import "FAArrayDescription.h"
#import "FAPropertyDescription.h"
#import "FAObjectDescription+Functions.h"


// Methods
extern FAObjectDescription *AdaptObject(Class klass, NSDictionary *description);
extern FAPropertyDescription *AdaptProperty(NSString *string);
extern FAArrayDescription *AdaptArray(id<FADescription> description);

NS_ENUM(int, FAAdaptErrors) {
    REQUIRED,
    DESCRIPTOR_OVERFLOW
};

extern NSString * const kFAAdaptErrorDomain;