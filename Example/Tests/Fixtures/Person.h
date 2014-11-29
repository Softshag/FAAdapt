//
//  Person.h
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 06/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Address.h"
@interface Person : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, strong) Address *address;

@end
