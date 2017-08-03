//
//  ViewController.m
//  JSContactBook
//
//  Created by Jayesh on 8/2/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "ViewController.h"
#import "ContactTableViewCell.h"

#import "ContactManager.h"

@interface ViewController ()
{
    NSMutableArray *arrayContact;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    arrayContact = [[NSMutableArray alloc] init];
    
    [[ContactManager sharedContactManager] requestContactManagerWithCompletion:^(BOOL success, NSError *error) {
       
        if (success) {
            NSLog(@"Access granted...");
            
            [[ContactManager sharedContactManager] fetchContactsWithCompletion:^(NSArray *arrayContacts, NSError *error) {
               
                arrayContact = [arrayContacts mutableCopy];
                NSLog(@"%@",arrayContacts);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
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

#pragma mark - Table View Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayContact.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CNContact *contact = [arrayContact objectAtIndex:indexPath.row];
    
    ContactTableViewCell *cell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactTableViewCell class]) forIndexPath:indexPath];
    
    if (contact!=nil) {

        [cell.labelContactName setAttributedText:contact.displayName];
        
    }

    return cell;
}

@end
