//
//  ContactHistoryViewController.m
//  JSContactBook
//
//  Created by Jayesh on 8/9/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "ContactHistoryViewController.h"
#import "CallHistoryTableViewCell.h"
#import "CoreDataManager.h"
#import "UIImageView+AGCInitials.h"

@interface ContactHistoryViewController ()
{
    NSMutableArray *arrayContact;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ContactHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    arrayContact = [[CoreDataManager sharedCoreData].managedObjectContext getAllDataForEntity:NSStringFromClass([JSContactHistory class])].mutableCopy;
    [self.tableView reloadData];
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
    JSContactHistory *contactHistory = [arrayContact objectAtIndex:indexPath.row];
    
    CallHistoryTableViewCell *cell = (CallHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CallHistoryTableViewCell class]) forIndexPath:indexPath];
    
    if (contactHistory!=nil) {

        // Set name
        [cell.labelContactName setText:[NSString stringWithFormat:@"%@",contactHistory.contactDisplayName]];
        [cell.labelOperationText setText:[NSString stringWithFormat:@"%@",contactHistory.operation]];

        [cell.imageViewContact.layer setCornerRadius:cell.imageViewContact.frame.size.width/2];
        cell.imageViewContact.clipsToBounds = YES;
        
        [cell.imageViewContact agc_setImageWithInitialsFromName:contactHistory.contactDisplayName];

        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


@end
