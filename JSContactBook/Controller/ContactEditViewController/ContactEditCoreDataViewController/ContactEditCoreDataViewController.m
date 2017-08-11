//
//  ContactEditCoreDataViewController.m
//  JSContactBook
//
//  Created by bosleo8 on 10/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "ContactEditCoreDataViewController.h"
#import "ContactManager.h"
#import "CoreDataManager.h"
#import "ContactEditNameImageTableViewCell.h"
#import "ContactEditAddDataTableViewCell.h"
#import "ContactEditAddDetailTableViewCell.h"
#import "UIImageView+AGCInitials.h"

#import "NSManagedObject+DeepCopying.h"

typedef enum : NSUInteger {
    ContactEditCellTypeCoreDataImage = 0,
    ContactEditCellTypeCoreDataPhone,
    //    ContactEditCellTypeCoreDataEmail,
    //    ContactEditCellTypeCoreDataAddress,
    //    ContactEditCellTypeCoreDataBirthDay,
    ContactEditCellTypeCoreDataCount
} ContactEditCellTypeCoreData;

@interface ContactEditCoreDataViewController ()
{
    NSMutableArray *arrayPhoneNumbers;
}
@end

@implementation ContactEditCoreDataViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contactsUpdateNotification:)
                                                 name:kNotificationContactsUpdated
                                               object:nil];
    
    if (self.screenMode == ScreemModeCoreDataAdd) {
        self.contact = [[CoreDataManager sharedCoreData].managedObjectContext insertIntoEntity:NSStringFromClass([JSContact class])];
    }
    
    arrayPhoneNumbers = [self.contact.has_phone_numbers.allObjects orderby:@"phoneNumberIdentifier" acending:YES].mutableCopy;
    [self.tableView setEditing:YES animated:YES];

}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationContactsUpdated object:nil];
}

#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ContactEditCellTypeCoreDataCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == ContactEditCellTypeCoreDataImage) {
        return 1;
    }
    else if (section == ContactEditCellTypeCoreDataPhone) {
        return self.contact.has_phone_numbers.count + 1;
    }
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
    if (indexPath.section == ContactEditCellTypeCoreDataImage) {
        return 84.0f;
    }
    else if (indexPath.section == ContactEditCellTypeCoreDataPhone) // || indexPath.section == ContactCellTypeEmail || indexPath.section == ContactCellTypeBirthDay)
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
    if (indexPath.section == ContactEditCellTypeCoreDataImage) {
        return 84.0f;
    }
    else if (indexPath.section == ContactEditCellTypeCoreDataPhone) // || indexPath.section == ContactCellTypeEmail || indexPath.section == ContactCellTypeAddress || indexPath.section == ContactCellTypeBirthDay)
    {
        return 44.0f;
    }
    return 44.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ContactEditCellTypeCoreDataPhone) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        JSPhoneNumber *jsPhoneNumber = [self itemAtIndexPath:indexPath];
        [self.contact removeHas_phone_numbersObject:jsPhoneNumber];
        [self.tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        if (indexPath.section == ContactEditCellTypeCoreDataPhone && indexPath.row == self.contact.has_phone_numbers.count)
        {
            [self addContactNumber:@""];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.contact.has_phone_numbers.count -1) inSection:ContactEditCellTypeCoreDataPhone]] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            });
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ContactEditCellTypeCoreDataPhone)
    {
        if (indexPath.row == self.contact.has_phone_numbers.count) {
            return UITableViewCellEditingStyleInsert;
        }
        else
        {
            return UITableViewCellEditingStyleDelete;
        }
    }
    
    return UITableViewCellEditingStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ContactEditCellTypeCoreDataImage) {
        ContactEditNameImageTableViewCell *cell = (ContactEditNameImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactEditNameImageTableViewCell class]) forIndexPath:indexPath];
        
        if (self.contact!=nil) {
            
            // Set name
            [cell.textFieldFirstName setText:self.contact.givenName];
            [cell.textFieldLastName setText:self.contact.familyName];
            
            [cell.textFieldFirstName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [cell.textFieldLastName addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            // Set image
//            if (self.contact.imageData!=nil && self.contact.thumbnailImageData!=nil) {
//                [cell.imageViewContact setImage:[UIImage imageWithData:(self.contact.imageData!=nil)?self.contact.imageData:self.contact.thumbnailImageData]];
//            }
//            else
//            {
                [cell.imageViewContact agc_setImageWithInitialsFromName:self.contact.displayName];
//            }
            
            [cell.imageViewContact.layer setCornerRadius:cell.imageViewContact.frame.size.width/2];
            cell.imageViewContact.clipsToBounds = YES;
            
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    else if (indexPath.section == ContactEditCellTypeCoreDataPhone)
    {
        if (indexPath.row == self.contact.has_phone_numbers.count) {
            ContactEditAddDataTableViewCell *cell = (ContactEditAddDataTableViewCell *)[tableView dequeueReusableCellWithIdentifier :NSStringFromClass([ContactEditAddDataTableViewCell class]) forIndexPath:indexPath];
            
            [cell.labelTitle setText:@"add phone"];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
        else
        {
            ContactEditAddDetailTableViewCell *cell = (ContactEditAddDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactEditAddDetailTableViewCell class]) forIndexPath:indexPath];
            
            JSPhoneNumber *phoneNumber = [self itemAtIndexPath:indexPath];
            
            [cell.buttonDetailType setTitle:phoneNumber.label forState:UIControlStateNormal];
            [cell.buttonDetailType addTarget:self action:@selector(handlerSelectLabelType:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.textFieldValue setText:phoneNumber.phoneNumber];
            // Add a "textFieldDidChange" notification method to the text field control.
            [cell.textFieldValue addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
    }
    
    //    else if (indexPath.section == ContactEditCellTypeCoreDataPhone || indexPath.section == ContactCellTypeEmail || indexPath.section == ContactCellTypeBirthDay)
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

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == ContactEditCellTypeCoreDataPhone)
    {
        if (indexPath.row == self.contact.has_phone_numbers.count) {
            
            [self addContactNumber:@""];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:(self.contact.has_phone_numbers.count -1) inSection:ContactEditCellTypeCoreDataPhone]] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            });

        }
    }
}

#pragma mark - Button Event


- (IBAction)handlerCancel:(id)sender {
//    self.contact = self.contact.mutableCopy;.
    [[CoreDataManager sharedCoreData].managedObjectContext rollback];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handerDone:(id)sender {
    [self addOrUpdateContactDetails];
}

-(IBAction)handlerSelectLabelType:(UIButton*)sender
{
//    CGPoint textFieldOrigin = [self.tableView convertPoint:sender.bounds.origin fromView:sender];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:textFieldOrigin];
//    
//    NSArray *arrayPhoneNumberTypes = @[[CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberiPhone], [CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberMobile], [CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberMain], [CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberHomeFax], [CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberWorkFax], [CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberOtherFax], [CNLabeledValue localizedStringForLabel:CNLabelPhoneNumberPager]];
//    
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Select Label" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    [arrayPhoneNumberTypes enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        [actionSheet addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            [sender setTitle:obj forState:UIControlStateNormal];
//            
//            if (indexPath.section == ContactEditCellTypeCoreDataPhone) {
//                
//                CNLabeledValue<CNPhoneNumber*> *phoneNumber = [self itemAtIndexPath:indexPath];
//                
//                NSMutableArray *arrayPhoneNumber = (self.contact.phoneNumbers.mutableCopy)?self.contact.phoneNumbers.mutableCopy:[[NSMutableArray alloc] init];
//                
//                CNPhoneNumber * phone =[CNPhoneNumber phoneNumberWithStringValue:phoneNumber.value.stringValue];
//                [arrayPhoneNumber replaceObjectAtIndex:indexPath.row withObject:[CNLabeledValue labeledValueWithLabel:obj value:phone]];
//                
//                self.contact.phoneNumbers = arrayPhoneNumber;
//            }
//            
//            
//            [actionSheet dismissViewControllerAnimated:YES completion:nil];
//        }]];
//        
//    }];
//    
//    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//        [actionSheet dismissViewControllerAnimated:YES completion:nil];
//    }]];
//    
//    // Present action sheet.
//    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

#pragma mark - Notification

-(IBAction)contactsUpdateNotification:(id)sender
{
    id contactCurrent = [[CoreDataManager sharedCoreData].managedObjectContext getDataForEntity:NSStringFromClass([JSContact class]) Where:@"contactIdntifier = %@",self.contact.contactIdntifier].firstObject;
    if (contactCurrent!=nil) {
        self.contact = contactCurrent;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

#pragma mark - Text Field Delgate Method

-(IBAction)textFieldDidChange:(UITextField *)textField{
    
    CGPoint textFieldOrigin = [self.tableView convertPoint:textField.bounds.origin fromView:textField];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:textFieldOrigin];
    
    if (indexPath.section == ContactEditCellTypeCoreDataImage) {
        ContactEditNameImageTableViewCell *cell = (ContactEditNameImageTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];

        self.contact.givenName    = cell.textFieldFirstName.text;
        self.contact.familyName   = cell.textFieldLastName.text;
        self.contact.displayName  = self.contact.displayNameAttributed.string;
    }
    else if (indexPath.section == ContactEditCellTypeCoreDataPhone) {
        
        JSPhoneNumber *phoneNumber = [self itemAtIndexPath:indexPath];
        
        ContactEditAddDetailTableViewCell *cell = (ContactEditAddDetailTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        phoneNumber.label = cell.buttonDetailType.currentTitle;
        phoneNumber.phoneNumber = textField.text;
        
    }
}

#pragma mark - Item At Index Path

-(id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == ContactEditCellTypeCoreDataPhone) {
        JSPhoneNumber *arrayPhonenumbers = [arrayPhoneNumbers objectAtIndex:indexPath.row];
        return arrayPhonenumbers;
        
    }
    return nil;
}

#pragma mark - Contact Data Manipulation

-(void)addOrUpdateContactDetails
{
    NSError * error;

    // Save managed object in database.
    if ([[CoreDataManager sharedCoreData].managedObjectContext hasChanges]) {
        if (![[CoreDataManager sharedCoreData].managedObjectContext save:&error]) {
            // Add record in datbase history.
            return;
        }
    }

    if (!error) {
        
        CNMutableContact *mutableContact = [[ContactManager sharedContactManager].store unifiedContactWithIdentifier:self.contact.contactIdntifier keysToFetch:[ContactManager sharedContactManager].keys error:&error].mutableCopy;
        
        NSInteger count = [[CoreDataManager sharedCoreData].managedObjectContext getAllDataForEntity:NSStringFromClass([JSContactHistory class])].count;
        if (mutableContact==nil) {
            mutableContact = [[CNMutableContact alloc] init];
            JSContactHistory *conactEntity = [[CoreDataManager sharedCoreData].managedObjectContext insertIntoEntity:NSStringFromClass([JSContactHistory class])];
            conactEntity.historyId = (int32_t)count+1;
            conactEntity.contactId = mutableContact.identifier;
            conactEntity.operation = kContactOperationAdd;
            conactEntity.fieldType = kFieldTypeContact;
            ContactEditNameImageTableViewCell *cell = (ContactEditNameImageTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:ContactEditCellTypeCoreDataImage]];
            mutableContact.givenName    = cell.textFieldFirstName.text;
            mutableContact.familyName   = cell.textFieldLastName.text;
            conactEntity.contactDisplayName = mutableContact.displayName.string;
        }
        else
        {
            if ([self.contact compareCNContact:mutableContact withJSContact:self.contact forContext:[CoreDataManager sharedCoreData].managedObjectContext]) {
                JSContactHistory *conactEntity = [[CoreDataManager sharedCoreData].managedObjectContext insertIntoEntity:NSStringFromClass([JSContactHistory class])];
                conactEntity.historyId = (int32_t)count+1;
                conactEntity.contactId = mutableContact.identifier;
                conactEntity.operation = kContactOperationUpdated;
                conactEntity.fieldType = kFieldTypeContact;
                conactEntity.contactDisplayName = mutableContact.displayName.string;
            }
        }
        
        if (ContactEditCellTypeCoreDataCount>0)
        {
            for (int section = 0; section<ContactEditCellTypeCoreDataCount; section++) {
                
                if (section == ContactEditCellTypeCoreDataImage) {
                    
                    ContactEditNameImageTableViewCell *cell = (ContactEditNameImageTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:ContactEditCellTypeCoreDataImage]];
                    
                    mutableContact.givenName    = cell.textFieldFirstName.text;
                    mutableContact.familyName   = cell.textFieldLastName.text;
                    
                }
                
                if (section == ContactEditCellTypeCoreDataPhone) {
                    
                    NSMutableArray *arrayPhoneNumber = [[NSMutableArray alloc] init];
                    NSInteger rows = [self.tableView numberOfRowsInSection:section] - 1;
                    for (int row = 0; row<rows; row++) {
                        
                        NSIndexPath *indexPathPhoneNumber = [NSIndexPath indexPathForRow:row inSection:ContactEditCellTypeCoreDataPhone];
                        ContactEditAddDetailTableViewCell *cell = (ContactEditAddDetailTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPathPhoneNumber];
                        
                        if (cell.textFieldValue.text.length>0) {
                            
                            CNPhoneNumber * phone =[CNPhoneNumber phoneNumberWithStringValue:cell.textFieldValue.text];
                            CNLabeledValue *phoneNumber = [CNLabeledValue labeledValueWithLabel:cell.buttonDetailType.titleLabel.text value:phone];
                            [arrayPhoneNumber addObject:phoneNumber];
                            
                            JSPhoneNumber *phoneNumberUpdate = [self itemAtIndexPath:indexPathPhoneNumber];
                            phoneNumberUpdate.phoneNumberIdentifier = phoneNumber.identifier;
                            phoneNumberUpdate.label = cell.buttonDetailType.titleLabel.text;
                            
                        }
                        
                    }
                    
                    mutableContact.phoneNumbers = [arrayPhoneNumber mutableCopy];
                    
                }
            }
            
            [[ContactManager sharedContactManager] addOrUpdateContact:mutableContact withCompletion:^(BOOL success, NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
                
                if (success) {
                    NSLog(@"Contact updated successfully.");
                    
                    self.contact.contactIdntifier = mutableContact.identifier;
                    
                    // Save managed object in database.
                    if ([[CoreDataManager sharedCoreData].managedObjectContext hasChanges]) {
                        if (![[CoreDataManager sharedCoreData].managedObjectContext save:&error]) {
                            // Add record in datbase history.
                            return;
                        }
                    }
                }
                else
                {
                    NSLog(@"%@",[error localizedDescription]);
                }
                
            }];
        }
    }
}

-(void)addContactNumber:(NSString*)contactNumber
{
    JSPhoneNumber *jsPhoneNumber = [[CoreDataManager sharedCoreData].managedObjectContext insertIntoEntity:NSStringFromClass([JSPhoneNumber class])];
    jsPhoneNumber.label = [CNLabeledValue localizedStringForLabel:CNLabelHome];
    jsPhoneNumber.phoneNumber = contactNumber;
    jsPhoneNumber.belongs_to_contact = self.contact;
    
    arrayPhoneNumbers = (arrayPhoneNumbers == nil)?[[NSMutableArray alloc] init]:arrayPhoneNumbers;
    [arrayPhoneNumbers addObject:jsPhoneNumber];
}

@end
