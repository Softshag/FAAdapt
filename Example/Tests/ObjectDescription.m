//
//  FAAdaptTests.m
//  FAAdaptTests
//
//  Created by Rasmus Kildevæld on 11/29/2014.
//  Copyright (c) 2014 Rasmus Kildevæld. All rights reserved.
#import <FAPropertyDescription.h>
#import <FAArrayDescription.h>
#import <FAObjectDescription.h>

#import "Fixtures.h"

SPEC_BEGIN(ObjectDescription)

describe(@"ObjectDescription", ^{
    
    context(@"mapping", ^{
        
        it(@"dictionary", ^{
            FAObjectDescription *description = [[FAObjectDescription alloc] init];
            description.destinationClass = Person.class;
            
            [description addDescriptionDictionary:@{
              @"fn": @"firstName",
              @"ln": @"lastName",
              @"a": [FAPropertyDescription descriptionWithProperty:@"age"]
            }];
            
            
            NSDictionary *value = @{
              @"fn": @"Bill",
              @"ln": @"Peterson",
              @"a": @"22"
            };
            
            Person *person = [description mapValue:value error:nil];
            
            [[person.firstName should] equal:@"Bill"];
            [[person.lastName should] equal:@"Peterson"];
            [[person.age should] equal:@(22)];
        });
        
    });
    
    context(@"map", ^{
        it(@"can map values", ^{
        
        });
    });
    
});

SPEC_END
