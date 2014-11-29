//
//  Comment.h
//  FAAdapt
//
//  Created by Rasmus Kildevaeld on 29/11/14.
//  Copyright (c) 2014 Rasmus Kildevæld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Comment : NSObject

@property (nonatomic, strong) Person *author;
@property (nonatomic, strong) NSString *comment;

@end
