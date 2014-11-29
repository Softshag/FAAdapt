//
//  FAAdaptTests.m
//  FAAdaptTests
//
//  Created by Rasmus Kildevæld on 11/29/2014.
//  Copyright (c) 2014 Rasmus Kildevæld. All rights reserved.
#import <FAPropertyDescription.h>
#import <FAArrayDescription.h>

#import "Fixtures.h"

SPEC_BEGIN(ArrayDescription)

describe(@"FAArrayDescription", ^{
    
    context(@"constructor", ^{
        it(@"can construct", ^{
            FAPropertyDescription *propDesc = [FAPropertyDescription descriptionWithProperty:@"firstName" class:Person.class];
            
            FAArrayDescription *desc = [FAArrayDescription descriptionWithDescription:propDesc];
            
            FADescription *d = (FADescription*)desc.descriptor;
            
            [[d should] equal:propDesc];
            [[desc should] haveValue:NSArray.class forKey:@"destinationClass"];
            
        });
        
    });
    
    context(@"map", ^{
        it(@"can map values", ^{
            FAPropertyDescription *propDesc = [FAPropertyDescription new];
            propDesc.destinationClass = NSNumber.class;
            
            FAArrayDescription *desc = [FAArrayDescription descriptionWithDescription:propDesc];
            
            NSArray *value = @[@"2",@"3",@"4"];
            
            NSArray *newValue = [desc mapValue:value error:nil];
            
            [[newValue should] haveLengthOf:3];
            [[newValue[0] should] equal:@(2)];
            [[newValue[1] should] equal:@(3)];
            [[newValue[2] should] equal:@(4)];
            
        });
    });
    
});

SPEC_END
