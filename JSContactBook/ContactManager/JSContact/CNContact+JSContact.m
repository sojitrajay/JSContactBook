//
//  CNContact+JSContact.m
//  JSContactBook
//
//  Created by bosleo8 on 03/08/17.
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

    return [givenName trimString];
}

@end
