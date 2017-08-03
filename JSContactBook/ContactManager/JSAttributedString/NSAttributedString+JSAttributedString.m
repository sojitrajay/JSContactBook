//
//  NSAttributedString+JSAttributedString.m
//  JSContactBook
//
//  Created by Jayesh on 03/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "NSAttributedString+JSAttributedString.h"

@implementation NSMutableAttributedString (JSAttributedString)

-(NSAttributedString*)trimString
{
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSRange range           = [self.string rangeOfCharacterFromSet:charSet];
    while (range.length != 0 && range.location == 0)
    {
        [self replaceCharactersInRange:range
                                 withString:@""];
        range = [self.string rangeOfCharacterFromSet:charSet];
    }
    
    // Trim trailing whitespace and newlines.
    range = [self.string rangeOfCharacterFromSet:charSet
                                              options:NSBackwardsSearch];
    while (range.length != 0 && NSMaxRange(range) == self.length)
    {
        [self replaceCharactersInRange:range
                                 withString:@""];
        range = [self.string rangeOfCharacterFromSet:charSet
                                                  options:NSBackwardsSearch];
    }
    
    return self;
}

@end
