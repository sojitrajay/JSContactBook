//
//  CallHistoryTableViewCell.h
//  JSContactBook
//
//  Created by Jayesh on 8/9/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallHistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelOperationText;
@property (weak, nonatomic) IBOutlet UILabel *labelContactName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewContact;

@end
