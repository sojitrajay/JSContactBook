//
//  ContactDetailCoreDataViewController.m
//  JSContactBook
//
//  Created by bosleo8 on 10/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "ContactDetailCoreDataViewController.h"
#import "ContactImageTableViewCell.h"
#import "ContactTitleAndDetailTableViewCell.h"
#import "CoreDataManager.h"
#import "UIImageView+AGCInitials.h"
#import "ContactEditCoreDataViewController.h"
#import "ContactManager.h"

typedef enum : NSUInteger {
    ContactCellTypeCoreDataImage = 0,
    ContactCellTypeCoreDataPhone,
//    ContactCellTypeCoreDataEmail,
//    ContactCellTypeCoreDataAddress,
//    ContactCellTypeCoreDataBirthDay,
    ContactCellTypeCoreDataCount
} ContactCellTypeCoreData;

#define kSegueContactDetailToEdit   @"SegueContactDetailToEdit"

@interface ContactDetailCoreDataViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ContactDetailCoreDataViewController

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

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CNContactStoreDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:kSegueContactDetailToEdit]) {
        ContactEditCoreDataViewController *contactDetailVC = [segue destinationViewController];
        contactDetailVC.contact = sender;
        contactDetailVC.screenMode = ScreemModeCoreDataEdit;
    }
    
}
#pragma mark - Table View Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ContactCellTypeCoreDataCount;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == ContactCellTypeCoreDataImage) {
        return 1;
    }
    else if (section == ContactCellTypeCoreDataPhone) {
        return self.contact.has_phone_numbers.count;
    }    
    return 0;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == ContactCellTypeCoreDataImage) {
        return 144.0f;
    }
    else if (indexPath.section == ContactCellTypeCoreDataPhone) // || indexPath.section == ContactCellTypeCoreDataEmail || indexPath.section == ContactCellTypeCoreDataBirthDay)
    {
        return 56.0f;
    }
    /*else if (indexPath.section == ContactCellTypeCoreDataAddress)
    {
        return UITableViewAutomaticDimension;
    }*/
    return 44.0f;
}

-(CGFloat)tableView:(UITableView*)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == ContactCellTypeCoreDataImage) {
        return 144.0f;
    }
    else if (indexPath.section == ContactCellTypeCoreDataPhone)// || indexPath.section == ContactCellTypeCoreDataEmail || indexPath.section == ContactCellTypeCoreDataAddress || indexPath.section == ContactCellTypeCoreDataBirthDay)
    {
        return 56.0f;
    }
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == ContactCellTypeCoreDataImage) {
        ContactImageTableViewCell *cell = (ContactImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactImageTableViewCell class]) forIndexPath:indexPath];
        
        if (self.contact!=nil) {
            
            // Set name
            [cell.labelContactName setText:self.contact.displayName];
            
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
    else if (indexPath.section == ContactCellTypeCoreDataPhone) // || indexPath.section == ContactCellTypeCoreDataEmail || indexPath.section == ContactCellTypeCoreDataBirthDay)
    {
        ContactTitleAndDetailTableViewCell *cell = (ContactTitleAndDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactTitleAndDetailTableViewCell class]) forIndexPath:indexPath];
        
        if (self.contact!=nil) {
            if (indexPath.section == ContactCellTypeCoreDataPhone) {
                JSPhoneNumber *phoneNumber = [self itemAtIndexPath:indexPath];
                [cell.labelContactTitle setText:phoneNumber.label];
                [cell.labelContactDetail setText:phoneNumber.phoneNumber];
            }
            /*else if (indexPath.section == ContactCellTypeCoreDataEmail)
            {
                NSArray<CNLabeledValue<NSString*>*> *arrayEmails = self.contact.emailAddresses;
                CNLabeledValue<NSString*> *emailAddress = [arrayEmails objectAtIndex:indexPath.row];
                [cell.labelContactTitle setText:[CNLabeledValue localizedStringForLabel:emailAddress.label]];
                [cell.labelContactDetail setText:emailAddress.value];
            }
            else if (indexPath.section == ContactCellTypeCoreDataBirthDay)
            {
                [cell.labelContactTitle setText:@"birthday"];
                [cell.labelContactDetail setText:[NSDateFormatter localizedStringFromDate:self.contact.birthday.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle]];
            }*/
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    /*else if (indexPath.section == ContactCellTypeCoreDataAddress)
    {
        ContactAddressTableViewCell *cell = (ContactAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ContactAddressTableViewCell class]) forIndexPath:indexPath];
        
        NSArray<CNLabeledValue<CNPostalAddress*>*> *arrayAddresses = self.contact.postalAddresses;
        CNLabeledValue<CNPostalAddress*> *address = [arrayAddresses objectAtIndex:indexPath.row];
        CNPostalAddress *postalAddress = address.value;
        
        [cell.labelContactTitle setText:[CNLabeledValue localizedStringForLabel:address.label]];
        [cell.labelContactDetail setText:[CNLabeledValue localizedStringForLabel:[CNPostalAddressFormatter stringFromPostalAddress:postalAddress style:CNPostalAddressFormatterStyleMailingAddress]]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }*/
    
    return nil;
    
}

#pragma mark - Item At Index Path

-(id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == ContactCellTypeCoreDataPhone) {
        JSPhoneNumber *arrayPhonenumbers = [[self.contact.has_phone_numbers.allObjects orderby:@"phoneNumberIdentifier" acending:YES] objectAtIndex:indexPath.row];
        return arrayPhonenumbers;
        
    }
    return nil;
}

#pragma mark - Button Event

- (IBAction)handlerEdit:(id)sender {
    
    [self performSegueWithIdentifier:kSegueContactDetailToEdit sender:self.contact];
}

#pragma mark - Notification

-(IBAction)cnContactStoreDidChange:(id)sender
{
    [self.tableView reloadData];
}

@end
