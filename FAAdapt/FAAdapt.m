//
//  FAObjectMap.m
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 05/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FAAdapt.h"

FAObjectDescription *AdaptObject(Class klass, NSDictionary *description) {
    FAObjectDescription *desc = [FAObjectDescription descriptionWith:klass dictionary:description];
    return desc;
}

extern FAPropertyDescription *AdaptProperty(NSString *string) {
    FAPropertyDescription *desc = [FAPropertyDescription descriptionWithProperty:string];
    return desc;
}

FAArrayDescription *AdaptArray(id<FADescription> description) {
    FAArrayDescription *desc = [FAArrayDescription descriptionWithDescription:description];
    return desc;
}
