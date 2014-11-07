//
//  FAMapperValueTransformer.h
//  FAMapper
//
//  Created by Rasmus Kildevaeld on 23/11/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAAdaptValueTransformer : NSObject

+ (id)transformValue:(id)value toValueOfType:(Class)klass;

@end
