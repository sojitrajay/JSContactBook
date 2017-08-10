//
//  ContactEditAddDetailTableViewCell.h
//  JSContactBook
//
//  Created by Jayesh on 8/4/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSPhoneNumber+CoreDataClass.h"

@interface ContactEditAddDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textFieldValue;
@property (weak, nonatomic) IBOutlet UIButton *buttonDetailType;
@property (weak, nonatomic) IBOutlet UIButton *buttonMinus;

@property (strong) JSPhoneNumber *phoneNumber;

@end
