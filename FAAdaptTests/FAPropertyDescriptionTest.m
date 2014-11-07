//
//  FAPropertyDescriptionTest.m
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 06/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "Person.h"

#import "FAPropertyDescription.h"

@interface FAPropertyDescriptionTest : XCTestCase


@end

@implementation FAPropertyDescriptionTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructor {

    FAPropertyDescription *description = [FAPropertyDescription descriptionWithProperty:@"firstName" class:Person.class];
    XCTAssertEqual(description.destinationClass, NSString.class);
    XCTAssertEqual(description.property, @"firstName");
}

- (void)testConstructorException {
    XCTAssertThrows([FAPropertyDescription descriptionWithProperty:@"name" class:Person.class]);
}

- (void)testValueMapping {
    FAPropertyDescription *description = [FAPropertyDescription descriptionWithProperty:@"firstName" class:Person.class];
    
    NSString *firstName = @"Bill";
    
    id result = [description mapValue:firstName error:nil];
    
    // Check nil
    XCTAssertNotNil(result);
    XCTAssertEqualObjects(result,firstName);
}

- (void)testValueMappingNoClassError {
    FAPropertyDescription *description = [FAPropertyDescription descriptionWithProperty:@"firstName"];
    
    NSError *error;
    
    id value = [description mapValue:@"Test" error:&error];
    
    XCTAssertNotNil(error);
    XCTAssertTrue([error.domain isEqualToString:@"com.morph.property"]);
    XCTAssertEqual(error.code, 1);

    
}

- (void)testValueTypeMap {
    FAPropertyDescription *description = [FAPropertyDescription descriptionWithProperty:@"age" class:Person.class];
    
    NSString *age = @"35";
    
    NSNumber *result = [description mapValue:age error:nil];
    
    XCTAssertEqual(description.destinationClass, NSNumber.class, @"Destination class should be NSNumber");
    XCTAssertTrue([result isKindOfClass:NSNumber.class],@"Result should kind of NSNumber");
    XCTAssertEqual(result.integerValue, age.integerValue,@"Result should be 35");
    
    
}


- (void)testValueConvertMap {
    FAPropertyDescription *description = [FAPropertyDescription descriptionWithProperty:@"lastName" class:Person.class];
    description.convert(^(NSString *str, NSError **error){
        return [str substringToIndex:4];
    });
    
    NSString *name = @"Bill Person";
    
    NSString *result = [description mapValue:name error:nil];
    
    XCTAssertTrue([result isEqualToString:[name substringToIndex:4]]);

}

- (void)testValueConvertMapError {
    FAPropertyDescription *description = [FAPropertyDescription descriptionWithProperty:@"lastName" class:Person.class];
    description.convert(^(NSString *str, NSError **error){
        *error = [NSError errorWithDomain:@"com.convert.domain" code:1 userInfo:nil];
        return (id)nil;
    });
    
    NSError *error;
    
    NSString *name = [description mapValue:@"Bill" error:&error];
    
    XCTAssertNotNil(error);
    XCTAssertTrue([error.domain isEqualToString:@"com.convert.domain"]);
    XCTAssertEqual(error.code, 1);
}



@end
