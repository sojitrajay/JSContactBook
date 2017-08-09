//
//  ContactEditViewController.m
//  JSContactBook
//
//  Created by Jayesh on 8/3/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "ContactEditViewController.h"
#import "ContactEditNameImageTableViewCell.h"
#import "ContactEditAddDataTableViewCell.h"
#import "ContactEditAddDetailTableViewCell.h"

#import "UIImageView+AGCInitials.h"

#import "ContactManager.h"

typedef enum : NSUInteger {
    ContactEditCellTypeImage = 0,
    ContactEditCellTypePhone,
//    ContactEditCellTypeEmail,
//    ContactEditCellTypeAddress,
//    ContactEditCellTypeBirthDay,
    ContactEditCellTypeCount
} ContactEditCellType;


@interface ContactEditViewController ()<UITextFieldDelegate,UITableViewDataSource>
{

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
    
    if (self.screenMode == ScreemModeAdd) {
        self.mutableContact = [[CNMutableContact alloc] init];
    }
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
    else if (section == ContactEditCellTypePhone) {
        return self.mutableContact.phoneNumbers.count + 1;
    }
//    else if (section == ContactCellTypeEmail) {
//        return self.mutableContact.emailAddresses.count;
//    }
//    else if (section == ContactCellTypeAddress)
//    {
//        return self.mutableContact.postalAddresses.count;
//    }
//    else if (section == ContactCellTypeBirthDay)
//    {
//        if (self.mutableContact.birthday!=nil) {
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
    else if (indexPath.section == ContactEditCellTypePhone) // || indexPath.section == ContactCellTypeEmail || indexPath.section == ContactCellTypeBirthDay)
    {
        return 44.0f;
    }
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
    else if (indexPath.section == ContactEditCellTypePhone) // || indexPath.section == ContactCellTypeEmail || indexPath.section == ContactCellTypeAddress || indexPath.section == ContactCellTypeBirthDay)
    {
        return 44.0f;
    }
    return 44.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ContactEditCellTypeImage) {
        ContactEditNameImageTableViewCell *cell = (ContactEditNameImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactEditNameImageTableViewCell class]) forIndexPath:indexPath];
        
        if (self.mutableContact!=nil) {
            
            // Set name
            [cell.textFieldFirstName setText:self.mutableContact.givenName];
            [cell.textFieldLastName setText:self.mutableContact.familyName];

            [cell.textFieldFirstName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [cell.textFieldLastName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

            // Set image
            if (self.mutableContact.imageData!=nil && self.mutableContact.thumbnailImageData!=nil) {
                [cell.imageViewContact setImage:[UIImage imageWithData:(self.mutableContact.imageData!=nil)?self.mutableContact.imageData:self.mutableContact.thumbnailImageData]];
            }
            else
            {
                [cell.imageViewContact agc_setImageWithInitialsFromName:self.mutableContact.displayName.string];
            }
            
            [cell.imageViewContact.layer setCornerRadius:cell.imageViewContact.frame.size.width/2];
            cell.imageViewContact.clipsToBounds = YES;
            
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    else if (indexPath.section == ContactEditCellTypePhone)
    {
        if (indexPath.row == self.mutableContact.phoneNumbers.count) {
            ContactEditAddDataTableViewCell *cell = (ContactEditAddDataTableViewCell *)[tableView dequeueReusableCellWithIdentifier :NSStringFromClass([ContactEditAddDataTableViewCell class]) forIndexPath:indexPath];
            
            [cell.labelTitle setText:@"add phone"];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            return cell;
        }
        else
        {
            ContactEditAddDetailTableViewCell *cell = (ContactEditAddDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactEditAddDetailTableViewCell class]) forIndexPath:indexPath];
            
            CNLabeledValue<CNPhoneNumber*> *phoneNumber = [self itemAtIndexPath:indexPath];
            CNPhoneNumber *number = phoneNumber.value;
            NSString *digits = number.stringValue;
            NSString *label = [CNLabeledValue localizedStringForLabel:phoneNumber.label];
            
            [cell.buttonDetailType setTitle:label forState:UIControlStateNormal];
            [cell.buttonDetailType addTarget:self action:@selector(handlerSelectLabelType:) forControlEvents:UIControlEventTouchUpInside];
            [cell.buttonMinus addTarget:self action:@selector(handlerMinus:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.textFieldValue setText:digits];

            // Add a "textFieldDidChange" notification method to the text field control.
            [cell.textFieldValue addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

            return cell;
        }
    }
    
//    else if (indexPath.section == ContactEditCellTypePhone || indexPath.section == ContactCellTypeEmail || indexPath.section == ContactCellTypeBirthDay)
//    {
//        ContactTitleAndDetailTableViewCell *cell = (ContactTitleAndDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactTitleAndDetailTableViewCell class]) forIndexPath:indexPath];
//        
//        if (self.mutableContact!=nil) {
//            if (indexPath.section == ContactCellTypePhone) {
//                NSArray<CNLabeledValue<CNPhoneNumber*>*> *arrayPhonenumbers = self.mutableContact.phoneNumbers;
//                CNLabeledValue<CNPhoneNumber*> *phoneNumber = [arrayPhonenumbers objectAtIndex:indexPath.row];
//                CNPhoneNumber *number = phoneNumber.value;
//                NSString *digits = number.stringValue;
//                NSString *label = [CNLabeledValue localizedStringForLabel:phoneNumber.label];
//                [cell.labelContactTitle setText:label];
//                [cell.labelContactDetail setText:digits];
//            }
//            else if (indexPath.section == ContactCellTypeEmail)
//            {
//                NSArray<CNLabeledValue<NSString*>*> *arrayEmails = self.mutableContact.emailAddresses;
//                CNLabeledValue<NSString*> *emailAddress = [arrayEmails objectAtIndex:indexPath.row];
//                [cell.labelContactTitle setText:[CNLabeledValue localizedStringForLabel:emailAddress.label]];
//                [cell.labelContactDetail setText:emailAddress.value];
//            }
//            else if (indexPath.section == ContactCellTypeBirthDay)
//            {
//                [cell.labelContactTitle setText:@"birthday"];
//                [cell.labelContactDetail setText:[NSDateFormatter localizedStringFromDate:self.mutableContact.birthday.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]];
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
//        NSArray<CNLabeledValue<CNPostalAddress*>*> *arrayAddresses = self.mutableContact.postalAddresses;
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

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == ContactEditCellTypePhone)
    {
        if (indexPath.row == self.mutableContact.phoneNumbers.count) {
            
            NSMutableArray *arrayPhoneNumber = (self.mutableContact.phoneNumbers.mutableCopy)?self.mutableContact.phoneNumbers.mutableCopy:[[NSMutableArray alloc] init];
            [arrayPhoneNumber addObject:[CNLabeledValue labeledValueWithLabel:CNLabelHome value:[[CNPhoneNumber alloc] initWithStringValue:@""]]];

            self.mutableContact.phoneNumbers = arrayPhoneNumber;
            
            [[ContactManager sharedContactManager] addOrUpdateContact:self.mutableContact withCompletion:^(BOOL success, NSError *error) {
                if (success) {
                    NSLog(@"Success");
                    self.mutableContact = self.mutableContact;
                    [self.tableView reloadData];
                }
                else
                {
                    NSLog(@"%@",error.localizedDescription);
                }
            }];

        }
        else
        {
        }
    }

}

#pragma mark - Button Event


- (IBAction)handlerCancel:(id)sender {
    self.mutableContact = self.contact.mutableCopy;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handerDone:(id)sender {
    [self addOrUpdateContactDetails];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handlerMinus:(UIButton*)sender {
    
    CGPoint textFieldOrigin = [self.tableView convertPoint:sender.bounds.origin fromView:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:textFieldOrigin];
    
    if (indexPath.section == ContactEditCellTypePhone)
    {
        if (indexPath.row == self.mutableContact.phoneNumbers.count) {
        }
        else
        {
//            ContactEditAddDetailTableViewCell *cell = (ContactEditAddDetailTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//            [cell setEditing:YES animated:YES];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }

    }
    
}

-(IBAction)handlerSelectLabelType:(UIButton*)sender
{
    CGPoint textFieldOrigin = [self.tableView convertPoint:sender.bounds.origin fromView:sender];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:textFieldOrigin];

    NSArray *arrayPhoneNumberTypes = @[[CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberiPhone], [CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberMobile], [CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberMain], [CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberHomeFax], [CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberWorkFax], [CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberOtherFax], [CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberPager]];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select Label" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [arrayPhoneNumberTypes enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [actionSheet addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [sender setTitle:obj forState:UIControlStateNormal];
            
            if (indexPath.section == ContactEditCellTypePhone) {
                
                CNLabeledValue<CNPhoneNumber*> *phoneNumber = [self itemAtIndexPath:indexPath];
                
                NSMutableArray *arrayPhoneNumber = (self.mutableContact.phoneNumbers.mutableCopy)?self.mutableContact.phoneNumbers.mutableCopy:[[NSMutableArray alloc] init];
                
                CNPhoneNumber * phone =[CNPhoneNumber phoneNumberWithStringValue:phoneNumber.value.stringValue];
                [arrayPhoneNumber replaceObjectAtIndex:indexPath.row withObject:[CNLabeledValue labeledValueWithLabel:obj value:phone]];
                
                self.mutableContact.phoneNumbers = arrayPhoneNumber;
            }
            
            
            [actionSheet dismissViewControllerAnimated:YES completion:nil];
        }]];

    }];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
    }]];

    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

#pragma mark - Notification

-(IBAction)cnContactStoreDidChange:(id)sender
{
    self.mutableContact = [[ContactManager sharedContactManager].store unifiedContactWithIdentifier:self.mutableContact.identifier keysToFetch:[ContactManager sharedContactManager].keys error:nil].mutableCopy;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Text Field Delgate Method

-(IBAction)textFieldDidChange:(UITextField *)textField{
    
    CGPoint textFieldOrigin = [self.tableView convertPoint:textField.bounds.origin fromView:textField];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:textFieldOrigin];
    
    if (indexPath.section == ContactEditCellTypeImage) {
        ContactEditNameImageTableViewCell *cell = (ContactEditNameImageTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];

        self.mutableContact.givenName    = cell.textFieldFirstName.text;
        self.mutableContact.familyName   = cell.textFieldLastName.text;
    }
    else if (indexPath.section == ContactEditCellTypePhone) {
        
        CNLabeledValue<CNPhoneNumber*> *phoneNumber = [self itemAtIndexPath:indexPath];
        
        NSMutableArray *arrayPhoneNumber = (self.mutableContact.phoneNumbers.mutableCopy)?self.mutableContact.phoneNumbers.mutableCopy:[[NSMutableArray alloc] init];
        [arrayPhoneNumber replaceObjectAtIndex:indexPath.row withObject:[CNLabeledValue labeledValueWithLabel:phoneNumber.label value:[[CNPhoneNumber alloc] initWithStringValue:textField.text]]];
        
        self.mutableContact.phoneNumbers = arrayPhoneNumber;
    }
}

#pragma mark - Item At Index Path

-(id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == ContactEditCellTypePhone) {
        
        NSArray<CNLabeledValue<CNPhoneNumber*>*> *arrayPhonenumbers = self.mutableContact.phoneNumbers;
        CNLabeledValue<CNPhoneNumber*> *phoneNumber = [arrayPhonenumbers objectAtIndex:indexPath.row];
        return phoneNumber;
       
    }

    return nil;
    
}

#pragma mark - Contact Data Manipulation

-(void)addOrUpdateContactDetails
{
    CNMutableContact *mutableContact = nil;
    
    if (self.screenMode == ScreemModeEdit){
        mutableContact = self.mutableContact;
    }
    else if (self.screenMode == ScreemModeAdd)
    {
        mutableContact = self.mutableContact;
    }
    
    if (ContactEditCellTypeCount>0)
    {
        for (int section = 0; section<ContactEditCellTypeCount; section++) {
            
            if (section == ContactEditCellTypeImage) {
                
                ContactEditNameImageTableViewCell *cell = (ContactEditNameImageTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:ContactEditCellTypeImage]];
                
                mutableContact.givenName    = cell.textFieldFirstName.text;
                mutableContact.familyName   = cell.textFieldLastName.text;
                
            }
            
            if (section == ContactEditCellTypePhone) {
                
                NSMutableArray *arrayPhoneNumber = [[NSMutableArray alloc] init];
                
                NSInteger rows = [self.tableView numberOfRowsInSection:section] - 1;
                for (int row = 0; row<rows; row++) {
                    
                    ContactEditAddDetailTableViewCell *cell = (ContactEditAddDetailTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:ContactEditCellTypePhone]];
                    
                    if (cell.textFieldValue.text.length>0) {
                        
                        CNPhoneNumber * phone =[CNPhoneNumber phoneNumberWithStringValue:cell.textFieldValue.text];
                        CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:cell.buttonDetailType.titleLabel.text value:phone];
                        [arrayPhoneNumber addObject:phoneNumber];
                        
                    }
                    
                }
                
                mutableContact.phoneNumbers = [arrayPhoneNumber mutableCopy];
                
            }
        }
        
        [[ContactManager sharedContactManager] addOrUpdateContact:mutableContact withCompletion:^(BOOL success, NSError *error) {
            if (success) {
                self.mutableContact = mutableContact;
            }
            else
            {
                NSLog(@"%@",[error localizedDescription]);
            }
        }];
    }
}

@end
