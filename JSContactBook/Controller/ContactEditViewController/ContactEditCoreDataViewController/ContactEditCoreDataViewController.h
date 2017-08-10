//
//  ContactEditCoreDataViewController.h
//  JSContactBook
//
//  Created by bosleo8 on 10/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSContact+CoreDataClass.h"

typedef enum : NSUInteger {
    ScreemModeCoreDataAdd = 0,
    ScreemModeCoreDataEdit
} ScreemModeCoreData;

@interface ContactEditCoreDataViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) JSContact *contact;
//@property (nonatomic) JSContact *mutableContact;

@property (nonatomic) ScreemModeCoreData screenMode;

@end
