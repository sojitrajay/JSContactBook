//
//  NSArray+Uitlity.m
//  eAudit
//
//  Created by Jayesh on 10/0/16.
//  Copyright © 2017 Jayesh All rights reserved.
//

#import "NSArray+Uitlity.h"

@implementation NSArray (Uitlity)

/**
 *  @author Jayesh
 *
 *  Evaluates the object check that is it NSArray type.
 *
 *  @param data Object that needs to check to evaluate.
 *
 *  @return Converted NSArray.
 */
+(NSArray *) evalueateObject:(id) data{
    
    if (data && [data isKindOfClass:[NSArray class]]) {
        
        NSArray *array = [NSArray arrayWithArray:(NSArray *)data];
        return array;
    }
    else{
        return [NSArray new];
    }
}

-(NSArray *) orderby:(NSString *) fieldName acending:(BOOL) value{
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:fieldName ascending:value];
    
    NSArray *array = [self sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    return array;
}

-(NSArray *) orderStringBy:(NSString *) fieldName acending:(BOOL) value{
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:[NSString stringWithFormat:@"%@.intValue",fieldName] ascending:value];
    
    NSArray *array = [self sortedArrayUsingDescriptors:@[sortDescriptor]];
    return array;
}

-(NSArray *) where:(NSString *) conditions, ...{
    
    va_list args;
    va_start(args, conditions);
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:conditions arguments:args];
    
    NSArray *array;
    
    if (self.count > 0) {
        array =[self filteredArrayUsingPredicate:predicate];
    }
    else{
        array =[NSArray new];
    }
    
    va_end(args);
    return array;
}

@end
