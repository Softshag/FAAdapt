//
//  Concert.h
//  FAObjectMapExample
//
//  Created by Rasmus Kildevaeld on 05/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Venue.h"
@interface Concert : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *finish;
@property (nonatomic) BOOL free;
@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, strong) NSURL *ticket;
@property (nonatomic, strong) NSString *festival;
@property (nonatomic, strong) Venue *venuer;
@property (nonatomic, strong) NSSet *acts;




@end
