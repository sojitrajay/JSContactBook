//
//  ContactImageTableViewCell.h
//  JSContactBook
//
//  Created by Jayesh on 03/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewContact;
@property (weak, nonatomic) IBOutlet UILabel *labelContactName;

@end
