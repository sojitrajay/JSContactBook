//
//  ContactEditViewController.m
//  JSContactBook
//
//  Created by Jayesh on 8/3/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "ContactEditViewController.h"
#import "ContactEditNameImageTableViewCell.h"
#import "UIImageView+AGCInitials.h"

typedef enum : NSUInteger {
    ContactEditCellTypeImage = 0,
//    ContactEditCellTypePhone,
//    ContactEditCellTypeEmail,
//    ContactEditCellTypeAddress,
//    ContactEditCellTypeBirthDay,
    ContactEditCellTypeCount
} ContactEditCellType;


@interface ContactEditViewController ()
{
    CNContact *tempContact;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ContactEditViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cnContactStoreDidChange:)
                                                 name:CNContactStoreDidChangeNotification
                                               object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ContactEditCellTypeCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == ContactEditCellTypeImage) {
        return 1;
    }
//    else if (section == ContactCellTypePhone) {
//        return self.contact.phoneNumbers.count;
//    }
//    else if (section == ContactCellTypeEmail) {
//        return self.contact.emailAddresses.count;
//    }
//    else if (section == ContactCellTypeAddress)
//    {
//        return self.contact.postalAddresses.count;
//    }
//    else if (section == ContactCellTypeBirthDay)
//    {
//        if (self.contact.birthday!=nil) {
//            return 1;
//        }
//    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == ContactEditCellTypeImage) {
        return 84.0f;
    }
//    else if (indexPath.section == ContactCellTypePhone || indexPath.section == ContactCellTypeEmail || indexPath.section == ContactCellTypeBirthDay){
//        return 56.0f;
//    }
//    else if (indexPath.section == ContactCellTypeAddress)
//    {
//        return UITableViewAutomaticDimension;
//    }
    return 44.0f;
}

-(CGFloat)tableView:(UITableView*)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == ContactEditCellTypeImage) {
        return 84.0f;
    }
//    else if (indexPath.section == ContactCellTypePhone || indexPath.section == ContactCellTypeEmail || indexPath.section == ContactCellTypeAddress || indexPath.section == ContactCellTypeBirthDay)
//    {
//        return 56.0f;
//    }
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ContactEditCellTypeImage) {
        ContactEditNameImageTableViewCell *cell = (ContactEditNameImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactEditNameImageTableViewCell class]) forIndexPath:indexPath];
        
        if (self.contact!=nil) {
            
            // Set name
            [cell.textFieldFirstName setText:self.contact.givenName];
            [cell.textFieldLastName setText:self.contact.familyName];

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
//    else if (indexPath.section == ContactCellTypePhone || indexPath.section == ContactCellTypeEmail || indexPath.section == ContactCellTypeBirthDay)
//    {
//        ContactTitleAndDetailTableViewCell *cell = (ContactTitleAndDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactTitleAndDetailTableViewCell class]) forIndexPath:indexPath];
//        
//        if (self.contact!=nil) {
//            if (indexPath.section == ContactCellTypePhone) {
//                NSArray<CNLabeledValue<CNPhoneNumber*>*> *arrayPhonenumbers = self.contact.phoneNumbers;
//                CNLabeledValue<CNPhoneNumber*> *phoneNumber = [arrayPhonenumbers objectAtIndex:indexPath.row];
//                CNPhoneNumber *number = phoneNumber.value;
//                NSString *digits = number.stringValue;
//                NSString *label = [CNLabeledValue localizedStringForLabel:phoneNumber.label];
//                [cell.labelContactTitle setText:label];
//                [cell.labelContactDetail setText:digits];
//            }
//            else if (indexPath.section == ContactCellTypeEmail)
//            {
//                NSArray<CNLabeledValue<NSString*>*> *arrayEmails = self.contact.emailAddresses;
//                CNLabeledValue<NSString*> *emailAddress = [arrayEmails objectAtIndex:indexPath.row];
//                [cell.labelContactTitle setText:[CNLabeledValue localizedStringForLabel:emailAddress.label]];
//                [cell.labelContactDetail setText:emailAddress.value];
//            }
//            else if (indexPath.section == ContactCellTypeBirthDay)
//            {
//                [cell.labelContactTitle setText:@"birthday"];
//                [cell.labelContactDetail setText:[NSDateFormatter localizedStringFromDate:self.contact.birthday.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]];
//            }
//        }
//        
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        
//        return cell;
//    }
//    else if (indexPath.section == ContactCellTypeAddress)
//    {
//        ContactAddressTableViewCell *cell = (ContactAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactAddressTableViewCell class]) forIndexPath:indexPath];
//        
//        NSArray<CNLabeledValue<CNPostalAddress*>*> *arrayAddresses = self.contact.postalAddresses;
//        CNLabeledValue<CNPostalAddress*> *address = [arrayAddresses objectAtIndex:indexPath.row];
//        CNPostalAddress *postalAddress = address.value;
//        
//        [cell.labelContactTitle setText:[CNLabeledValue localizedStringForLabel:address.label]];
//        [cell.labelContactDetail setText:[CNLabeledValue localizedStringForLabel:[CNPostalAddressFormatter stringFromPostalAddress:postalAddress style:CNPostalAddressFormatterStyleMailingAddress]]];
//        
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        
//        return cell;
//    }
    
    return nil;
    
}

#pragma mark - Button Event


- (IBAction)handlerCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handerDone:(id)sender {
    
    CNMutableContact *mutableContact = self.contact.mutableCopy;
    
    if (ContactEditCellTypeCount>0)
    {
        for (int section = 0; section<ContactEditCellTypeCount; section++) {
            if (section == ContactEditCellTypeImage) {
                
                ContactEditNameImageTableViewCell *cell = (ContactEditNameImageTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:ContactEditCellTypeImage]];

                mutableContact.givenName    = cell.textFieldFirstName.text;
                mutableContact.familyName   = cell.textFieldLastName.text;

            }
            
//    NSInteger rows = [self.tableView numberOfRowsInSection:section];
//    for (int i = 0; i<rows; i++) {
//
//    }

        }
        
        [[ContactManager sharedContactManager] updateContact:mutableContact withCompletion:^(NSError *error) {
            
            if (error==nil) {
                self.contact = mutableContact;
            }
            else
            {
                NSLog(@"%@",[error localizedDescription]);
            }
            
        }];

    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification

-(IBAction)cnContactStoreDidChange:(id)sender
{
    self.contact = [[ContactManager sharedContactManager].store unifiedContactWithIdentifier:self.contact.identifier keysToFetch:[ContactManager sharedContactManager].keys error:nil];
    [self.tableView reloadData];
}

@end
