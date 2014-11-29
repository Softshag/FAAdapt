//
//  FAAdaptTests.m
//  FAAdaptTests
//
//  Created by Rasmus Kildevæld on 11/29/2014.
//  Copyright (c) 2014 Rasmus Kildevæld. All rights reserved.
#import <FAPropertyDescription.h>
#import "Fixtures.h"

SPEC_BEGIN(PropertyDescription)

describe(@"FAPropertyDescription", ^{
    
    context(@"constructor", ^{
        
        it(@"can construct", ^{
            FAPropertyDescription *description = [FAPropertyDescription descriptionWithProperty:@"firstName" class:Person.class];
            [[description should] haveValue:NSString.class forKey:@"destinationClass"];
            [[description.property should] equal:@"firstName"];
        });
        
        it(@"throw exception", ^{
            [[theBlock(^{
                [FAPropertyDescription descriptionWithProperty:@"name" class:Person.class];
            }) should] raise];
            
        });
       
    });
    
    context(@"map", ^{
        
        it(@"can map values", ^{
            FAPropertyDescription *description = [FAPropertyDescription descriptionWithProperty:@"firstName" class:Person.class];
            
            NSString *firstName = @"Bill";
            
            id result = [description mapValue:firstName error:nil];
            
            [[result shouldNot] beNil];
            [[result should] equal:firstName];
        });
        
        it(@"should set error on no class", ^{
            FAPropertyDescription *description = [FAPropertyDescription descriptionWithProperty:@"firstName"];
            
            NSError *error;
            
            id value = [description mapValue:@"Test" error:&error];
            
            [[error shouldNot] beNil];
            //[[error.domain should] equal:@"com.morph.property"];
            [[theValue(error.code) should] equal:@(1)];
        });
        
        it(@"can convert object to destination class", ^{
            FAPropertyDescription *description = [FAPropertyDescription descriptionWithProperty:@"age" class:Person.class];
            
            NSString *age = @"35";
            
            NSNumber *result = [description mapValue:age error:nil];
            
            [[description should] haveValue:NSNumber.class forKey:@"destinationClass"];
            [[result should] beKindOfClass:NSNumber.class];
            [[result should] equal:@(35)];
        
        });
        
        it(@"should convert value with converter block", ^{
            FAPropertyDescription *description = [FAPropertyDescription descriptionWithProperty:@"lastName" class:Person.class];
            description.convert(^(NSString *str, NSError **error){
                return [str substringToIndex:4];
            });
            
            NSString *name = @"Bill Person";
            
            NSString *result = [description mapValue:name error:nil];
            
            [[result should] equal:[name substringToIndex:4]];
            
        });
        
        it(@"should set error when converting with converter block", ^{
            FAPropertyDescription *description = [FAPropertyDescription descriptionWithProperty:@"lastName" class:Person.class];
            description.convert(^(NSString *str, NSError **error){
                *error = [NSError errorWithDomain:@"com.convert.domain" code:1 userInfo:nil];
                return (id)nil;
            });
            
            NSError *error;
            
            NSString *name = [description mapValue:@"Bill" error:&error];
            
            [[error shouldNot] beNil];
            [[error.domain should] equal:@"com.convert.domain"];
            [[theValue(error.code) should] equal:theValue(1)];
        });
        
        
    });
    
});

SPEC_END
