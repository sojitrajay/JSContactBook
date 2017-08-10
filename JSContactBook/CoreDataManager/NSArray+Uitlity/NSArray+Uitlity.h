//
//  NSArray+Uitlity.h
//  eAudit
//
//  Created by Jayesh on 10/0/16.
//  Copyright © 2017 Jayesh All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Uitlity)

+(NSArray *) evalueateObject:(id) data;
-(NSArray *) orderStringBy:(NSString *) fieldName acending:(BOOL) value;

-(NSArray *) where:(NSString *) conditions, ...;
-(NSArray *) orderby:(NSString *) fieldName acending:(BOOL) value;
@end
