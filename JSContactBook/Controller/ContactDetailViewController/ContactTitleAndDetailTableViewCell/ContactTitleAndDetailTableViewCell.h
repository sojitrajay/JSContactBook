//
//  ContactTitleAndDetailTableViewCell.h
//  JSContactBook
//
//  Created by Jayesh on 8/3/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTitleAndDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelContactTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelContactDetail;

@end
