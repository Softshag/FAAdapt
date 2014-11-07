//
//  main.m
//  FAAdaptExample
//
//  Created by Rasmus Kildevaeld on 07/11/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FAObjectDescription.h"
#import "FAAdapt.h"
#import "Concert.h"
#import "Act.h"
#import "Genre.h"

#import <objc/runtime.h>

#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSString *file = [[NSBundle mainBundle] pathForResource:@"concert" ofType:@"json"];
        
        NSData *data = [NSData dataWithContentsOfFile:file];
        
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        
        FAObjectDescription *desc = AdaptObject(Concert.class, @{
          //@"name": @"title",
          @"description": @"desc",
          @"ticket": @"ticket",
          @"start": AdaptProperty(@"start").convert(^(NSNumber *value, NSError **error) {
            return [NSDate dateWithTimeIntervalSince1970:value.integerValue];
          }),
          @"free" : @"free",
          @"acts": AdaptArray(AdaptObject(Act.class, @{
            @"name": @"name"
          })),
          @"genres": AdaptArray(AdaptObject(Genre.class, @{
            @"genres": @"name"
          }))
        }).create(^(Class class, NSDictionary *value) {
            Concert *concert = [Concert new];
            return concert;
        });
        
        desc.prop(@"name",@"title");
        FAObjectDescription *venue = desc.object(@"venue", @"venuer", nil);
        
        venue.mapUndefinedProperties = YES;
        
        //desc.mapUndefinedProperties = YES;
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[json count]];
        TICK;
        /*for (NSDictionary *dict in (NSArray*)json) {
         Concert* value = [desc mapValue:dict error:nil];
         
         [array addObject:value];
         }*/
        
        TOCK;
        
        Concert *value = [desc mapValue:json error:nil];
        
        unsigned int cProperties = 0;
        objc_property_t *props = class_copyPropertyList(value.class, &cProperties);
        for(int i = 0; i < cProperties; i++) {
            const char *name = property_getName(props[i]);
            NSLog(@"%s=%@", name, [value valueForKey:@(name)]);
        }
        //NSLog(@"Desc %i",array.count);
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    return 0;
}
