//
//  ContactEditViewController.h
//  JSContactBook
//
//  Created by Jayesh on 8/3/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactManager.h"

typedef enum : NSUInteger {
    ScreemModeAdd = 0,
    ScreemModeEdit
} ScreemMode;

@interface ContactEditViewController : UIViewController

@property (nonatomic) CNContact *contact;

@property (nonatomic) ScreemMode screenMode;

@end
