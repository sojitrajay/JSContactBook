//
//  ViewController.m
//  JSContactBook
//
//  Created by Jayesh on 8/2/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "ViewController.h"

#import "ContactManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [[ContactManager sharedContactManager] requestContactManagerWithCompletion:^(BOOL success, NSError *error) {
       
        if (success) {
            NSLog(@"Access granted...");
            
            [[ContactManager sharedContactManager] fetchContactsWithCompletion:^(NSArray *arrayContacts, NSError *error) {
               
                NSLog(@"%@",arrayContacts);
                
            }];
            
        }
        else
        {
            NSLog(@"No access...");
        }
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
