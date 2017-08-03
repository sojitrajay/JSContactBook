//
//  ContactTableViewCell.h
//  JSContactBook
//
//  Created by bosleo8 on 03/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewThumbContact;
@property (weak, nonatomic) IBOutlet UILabel *labelContactName;

@end
