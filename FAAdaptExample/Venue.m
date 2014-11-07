//
//  Venue.m
//  FAObjectMapExample
//
//  Created by Rasmus Kildevaeld on 05/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "Venue.h"

@implementation Venue


- (NSString *)description {
    return [NSString stringWithFormat:@"{Name: %@, City: %@, Country: %@}",self.name,self.city,self.country];
}

@end
