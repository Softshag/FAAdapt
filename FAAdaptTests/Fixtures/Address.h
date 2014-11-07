//
//  Address.h
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 06/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Address : NSObject

@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
