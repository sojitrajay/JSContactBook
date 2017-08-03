//
//  ContactEditNameImageTableViewCell.h
//  JSContactBook
//
//  Created by Jayesh on 8/3/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactEditNameImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewContact;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstName;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastName;

@end
