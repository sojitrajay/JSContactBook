    //
//  ContactListCoreDataViewController.m
//  JSContactBook
//
//  Created by Jayesh on 09/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "ContactListCoreDataViewController.h"
#import "ContactManager.h"
#import "CoreDataManager.h"
#import "ContactTableViewCell.h"
#import "UIImageView+AGCInitials.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ContactDetailCoreDataViewController.h"
#import "UIImageView+AGCInitials.h"

#define kSegueContactListToCoreDataDetail   @"SegueContactListToCoreDataDetail"

@interface ContactListCoreDataViewController ()
{
    NSMutableArray *arrayContact;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewNoData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonItemAdd;

@end

@implementation ContactListCoreDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cnContactStoreDidChange:)
                                                 name:CNContactStoreDidChangeNotification
                                               object:nil];
    
    arrayContact = [[[CoreDataManager sharedCoreData].managedObjectContext getAllDataForEntity:NSStringFromClass([JSContact class])] orderby:@"contactIdntifier" acending:YES].mutableCopy;
    [self loadContacts];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if( status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted)
    {
        NSLog(@"access denied");
        [self.viewNoData setHidden:NO];
    }
    else
    {
        [self.viewNoData setHidden:YES];
    }
    [self.tableView reloadData];
    
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:kSegueContactListToCoreDataDetail]) {
        ContactDetailCoreDataViewController *contactDetailVC = [segue destinationViewController];
        contactDetailVC.contact = sender;
    }
    
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
}

#pragma mark - Table View Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayContact.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSContact *contact = [arrayContact objectAtIndex:indexPath.row];
    
    ContactTableViewCell *cell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactTableViewCell class]) forIndexPath:indexPath];
    
    if (contact!=nil) {
        
        // Set name
        [cell.labelContactName setAttributedText:contact.displayNameAttributed];
        
        //      Used to display name using CNContactFormatter in application. But it doesn't display same as iOS contact book.
        //        CNContactFormatter *formatter = [[CNContactFormatter alloc] init];
        //        formatter.style = CNContactFormatterStylePhoneticFullName;
        //        [cell.labelContactName setText:[formatter stringFromContact:contact]];
        
        // Set image
//        if (contact.imageData!=nil && contact.thumbnailImageData!=nil) {
//            [cell.imageViewThumbContact setImage:[UIImage imageWithData:(contact.thumbnailImageData!=nil)?contact.thumbnailImageData:contact.imageData]];
//        }
//        else
//        {
            [cell.imageViewThumbContact agc_setImageWithInitialsFromName:contact.displayName];
//        }
        
        [cell.imageViewThumbContact.layer setCornerRadius:cell.imageViewThumbContact.frame.size.width/2];
        cell.imageViewThumbContact.clipsToBounds = YES;
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Table View Delegate Methods

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    JSContact *contact = [arrayContact objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:kSegueContactListToCoreDataDetail sender:contact];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        JSContact *contact = [arrayContact objectAtIndex:indexPath.row];
        NSError *error = nil;
        
        CNContact *contactCN = [[ContactManager sharedContactManager].store unifiedContactWithIdentifier:contact.contactIdntifier keysToFetch:[ContactManager sharedContactManager].keys error:&error];
        [[ContactManager sharedContactManager] deleteContact:contactCN.mutableCopy withCompletion:^(BOOL success, NSError *error) {

            if (success) {
                [arrayContact removeObjectAtIndex:indexPath.row];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                });

            }
            else
            {
                NSLog(@"%@",[error localizedDescription]);
            }
        }];
        
    }
}

#pragma mark - Load Contacts

-(void)loadContacts
{
    [[ContactManager sharedContactManager] requestContactManagerWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            if (arrayContact.count<=0) {
                [SVProgressHUD show];
            }
            [[ContactManager sharedContactManager] fetchContactsWithCompletion:^(NSArray *arrayContacts, NSError *error) {
                
                arrayContact = [[CoreDataManager sharedCoreData].managedObjectContext getAllDataForEntity:NSStringFromClass([JSContact class])].mutableCopy;
                NSLog(@"%@",arrayContacts);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [SVProgressHUD dismiss];
                });
                
                // All instances of TestClass will be notified
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationContactsUpdated object:self];

            }];
            
        }
        else
        {
            [SVProgressHUD dismiss];
            NSLog(@"No access to contacts...");
        }
    }];
}

-(IBAction)cnContactStoreDidChange:(id)sender
{
    [self loadContacts];
}


@end
