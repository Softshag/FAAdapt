//
//  FAObjectDescriptionTest.m
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 06/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "FAObjectDescription.h"
#import "FAPropertyDescription.h"

#import "Person.h"
#import "Address.h"

@interface FAObjectDescriptionTest : XCTestCase

@property (nonatomic, strong) NSDictionary *json;

@end

@implementation FAObjectDescriptionTest

- (void)setUp {
    [super setUp];
    //NSString *str = @""
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"person" ofType:@"json"]];
    self.json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddProperty {
    // This is an example of a functional test case.
    FAObjectDescription *description = [FAObjectDescription descriptionWith:Person.class];
    
    FAPropertyDescription *prop = [FAPropertyDescription descriptionWithProperty:@"firstName"];
    
    [description addDescription:prop forProperty:@"first_name"];
    
    id desc = [description getDescription:@"first_name"];
    
    Person *person = [description mapValue:self.json error:nil];
    
    XCTAssertEqualObjects(prop, desc);
    XCTAssertEqual(person.firstName, self.json[@"first_name"]);
    XCTAssertNil(person.lastName);
    XCTAssertNil(person.age);
    XCTAssertNil(person.address);
}

- (void)testAddDictionaryStrings {
    FAObjectDescription *description = [FAObjectDescription descriptionWith:Person.class];
    
    [description addDescriptionDictionary:@{
      @"first_name": @"firstName",
      @"last_name": @"lastName",
      @"age": @"age"
    }];
    
    Person *person = [description mapValue:self.json error:nil];
    
    XCTAssertEqual(self.json[@"first_name"], person.firstName);
    XCTAssertEqual(self.json[@"last_name"], person.lastName);
    XCTAssertEqual(self.json[@"age"], person.age);
    XCTAssertNil(person.address);
}


- (void)testAddDictionaryDescription {
    FAObjectDescription *description = [FAObjectDescription descriptionWith:Person.class];
    
    [description addDescriptionDictionary:@{
      @"address": [FAObjectDescription descriptionWith:Address.class dictionary:@{
        @"street": @"street",
        @"city": @"city",
        @"country": @"country",
        @"latitude": @"latitude",
        @"longitude": @"longitude"
      }]
    }];
    
    Person *person = [description mapValue:self.json error:nil];
    
    XCTAssertNotNil(person.address);
    
    NSDictionary *address = self.json[@"address"];
    
    XCTAssertEqual(person.address.street, address[@"street"]);
    XCTAssertEqual(person.address.city, address[@"city"]);
    XCTAssertEqual(person.address.country, address[@"country"]);
                                                
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
