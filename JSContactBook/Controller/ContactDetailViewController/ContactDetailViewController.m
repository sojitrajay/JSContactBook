//
//  ContactDetailViewController.m
//  JSContactBook
//
//  Created by Jayesh on 03/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "ContactImageTableViewCell.h"
#import "ContactTitleAndDetailTableViewCell.h"
#import "ContactAddressTableViewCell.h"
#import "ContactEditViewController.h"

#import "UIImageView+AGCInitials.h"

#define kSegueContactListToDetail   @"contactDetailToEdit"

typedef enum : NSUInteger {
    ContactCellTypeImage = 0,
    ContactCellTypePhone,
    ContactCellTypeEmail,
    ContactCellTypeAddress,
    ContactCellTypeBirthDay,
    ContactCellTypeCount
} ContactCellType;

@interface ContactDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cnContactStoreDidChange:)
                                                 name:CNContactStoreDidChangeNotification
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:kSegueContactListToDetail]) {
        ContactEditViewController *contactEditVC = [segue destinationViewController];
        contactEditVC.contact = sender;
        contactEditVC.screenMode = ScreemModeEdit;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ContactCellTypeCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == ContactCellTypeImage) {
        return 1;
    }
    else if (section == ContactCellTypePhone) {
        return self.contact.phoneNumbers.count;
    }
    else if (section == ContactCellTypeEmail) {
        return self.contact.emailAddresses.count;
    }
    else if (section == ContactCellTypeAddress)
    {
        return self.contact.postalAddresses.count;
    }
    else if (section == ContactCellTypeBirthDay)
    {
        if (self.contact.birthday!=nil) {
            return 1;
        }
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == ContactCellTypeImage) {
        return 144.0f;
    }
    else if (indexPath.section == ContactCellTypePhone || indexPath.section == ContactCellTypeEmail || indexPath.section == ContactCellTypeBirthDay){
        return 56.0f;
    }
    else if (indexPath.section == ContactCellTypeAddress)
    {
        return UITableViewAutomaticDimension;
    }
    return 44.0f;
}

-(CGFloat)tableView:(UITableView*)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == ContactCellTypeImage) {
        return 144.0f;
    }
    else if (indexPath.section == ContactCellTypePhone || indexPath.section == ContactCellTypeEmail || indexPath.section == ContactCellTypeAddress || indexPath.section == ContactCellTypeBirthDay)
    {
        return 56.0f;
    }
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ContactCellTypeImage) {
        ContactImageTableViewCell *cell = (ContactImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactImageTableViewCell class]) forIndexPath:indexPath];
        
        if (self.contact!=nil) {
            
            // Set name
            [cell.labelContactName setText:self.contact.displayName.string];
            
            // Set image
            if (self.contact.imageData!=nil && self.contact.thumbnailImageData!=nil) {
                [cell.imageViewContact setImage:[UIImage imageWithData:(self.contact.imageData!=nil)?self.contact.imageData:self.contact.thumbnailImageData]];
            }
            else
            {
                [cell.imageViewContact agc_setImageWithInitialsFromName:self.contact.displayName.string];
            }
            
            [cell.imageViewContact.layer setCornerRadius:cell.imageViewContact.frame.size.width/2];
            cell.imageViewContact.clipsToBounds = YES;
            
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    else if (indexPath.section == ContactCellTypePhone || indexPath.section == ContactCellTypeEmail || indexPath.section == ContactCellTypeBirthDay)
    {
        ContactTitleAndDetailTableViewCell *cell = (ContactTitleAndDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactTitleAndDetailTableViewCell class]) forIndexPath:indexPath];
        
        if (self.contact!=nil) {
            if (indexPath.section == ContactCellTypePhone) {
                NSArray<CNLabeledValue<CNPhoneNumber*>*> *arrayPhonenumbers = self.contact.phoneNumbers;
                CNLabeledValue<CNPhoneNumber*> *phoneNumber = [arrayPhonenumbers objectAtIndex:indexPath.row];
                CNPhoneNumber *number = phoneNumber.value;
                NSString *digits = number.stringValue;
                NSString *label = [CNLabeledValue localizedStringForLabel:phoneNumber.label];
                [cell.labelContactTitle setText:label];
                [cell.labelContactDetail setText:digits];
            }
            else if (indexPath.section == ContactCellTypeEmail)
            {
                NSArray<CNLabeledValue<NSString*>*> *arrayEmails = self.contact.emailAddresses;
                CNLabeledValue<NSString*> *emailAddress = [arrayEmails objectAtIndex:indexPath.row];
                [cell.labelContactTitle setText:[CNLabeledValue localizedStringForLabel:emailAddress.label]];
                [cell.labelContactDetail setText:emailAddress.value];
            }
            else if (indexPath.section == ContactCellTypeBirthDay)
            {
                [cell.labelContactTitle setText:@"birthday"];
                [cell.labelContactDetail setText:[NSDateFormatter localizedStringFromDate:self.contact.birthday.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]];
            }
        }

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    else if (indexPath.section == ContactCellTypeAddress)
    {
        ContactAddressTableViewCell *cell = (ContactAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactAddressTableViewCell class]) forIndexPath:indexPath];
        
        NSArray<CNLabeledValue<CNPostalAddress*>*> *arrayAddresses = self.contact.postalAddresses;
        CNLabeledValue<CNPostalAddress*> *address = [arrayAddresses objectAtIndex:indexPath.row];
        CNPostalAddress *postalAddress = address.value;

        [cell.labelContactTitle setText:[CNLabeledValue localizedStringForLabel:address.label]];
        [cell.labelContactDetail setText:[CNLabeledValue localizedStringForLabel:[CNPostalAddressFormatter stringFromPostalAddress:postalAddress style:CNPostalAddressFormatterStyleMailingAddress]]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    return nil;
    
}

#pragma mark - Button Event

- (IBAction)handlerEdit:(id)sender {

    [self performSegueWithIdentifier:kSegueContactListToDetail sender:self.contact];
}

#pragma mark - Notification

-(IBAction)cnContactStoreDidChange:(id)sender
{
    self.contact = [[ContactManager sharedContactManager].store unifiedContactWithIdentifier:self.contact.identifier keysToFetch:[ContactManager sharedContactManager].keys error:nil];
    [self.tableView reloadData];
}

@end
