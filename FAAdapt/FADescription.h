//
//  FADescription.h
//  FAObjectMap
//
//  Created by Rasmus Kildevaeld on 05/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kErrorDomain;

// For instantiating a new object
typedef id (^createObjectBlock)(Class class, id value);

@protocol FADescription <NSObject>

@property (nonatomic, copy) Class destinationClass;
@property (nonatomic, copy) NSString *property;

//@property (nonatomic, copy) createObjectBlock creator;

- (id)mapValue:(id)value error:(NSError **)error;

@end


@interface FADescription : NSObject <FADescription> {
    id (^_creator)(Class class, id value);
}

+ (instancetype)descriptionWithProperty:(NSString *)property;

+ (instancetype)descriptionWithProperty:(NSString *)property class:(Class)destClass;


@property (nonatomic, copy, readonly) FADescription * (^create)(id (^creator)(Class class, id value));
@property (nonatomic, copy, readonly) FADescription * (^map)(NSString *property);

@property (nonatomic, copy) NSString *property;

@end
