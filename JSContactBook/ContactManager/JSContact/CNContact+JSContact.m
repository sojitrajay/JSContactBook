//
//  CNContact+JSContact.m
//  JSContactBook
//
//  Created by Jayesh on 03/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "CNContact+JSContact.h"
#import <UIKit/UIKit.h>
#import "NSAttributedString+JSAttributedString.h"

@implementation CNContact (JSContact)

-(NSAttributedString*)displayName
{
    NSDictionary *attributeNormalText = @{
                            NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]],
                            NSForegroundColorAttributeName:[UIColor blackColor]
                            };
    NSMutableAttributedString *givenName   = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ ",self.givenName] attributes:attributeNormalText];
    
    NSDictionary *attributeBoldText = @{
                            NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]],
                            NSForegroundColorAttributeName:[UIColor blackColor]
                            };
    NSMutableAttributedString *familyName  = [[NSMutableAttributedString alloc]initWithString:self.familyName attributes:attributeBoldText];
    
    [givenName appendAttributedString:familyName];

    if ([givenName trimString].length>0) {
        return [givenName trimString];
    }
    else
    {
        NSDictionary *attributeItalicText = @{
                                            NSFontAttributeName:[UIFont italicSystemFontOfSize:[UIFont systemFontSize]],
                                            NSForegroundColorAttributeName:[UIColor blackColor]
                                            };
        NSMutableAttributedString *name  = [[NSMutableAttributedString alloc]initWithString:@"No Name" attributes:attributeItalicText];
        return name;
    }
    
}

@end
