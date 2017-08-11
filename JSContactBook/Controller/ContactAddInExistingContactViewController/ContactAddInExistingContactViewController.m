//
//  ContactAddInExistingContactViewController.m
//  JSContactBook
//
//  Created by bosleo8 on 10/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "ContactAddInExistingContactViewController.h"
#import "ContactEditCoreDataViewController.h"

#define kSegueAddContacToEditContact    @"addContacToEditContact"

@interface ContactAddInExistingContactViewController ()<CNContactPickerDelegate>
{
    CNContactPickerViewController *contactPicker;
}
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;
@end

@implementation ContactAddInExistingContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    contactPicker = [[CNContactPickerViewController alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(CNContact*)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:kSegueAddContacToEditContact]) {
        
        JSContact *contact = [[CoreDataManager sharedCoreData].managedObjectContext getDataForEntity:NSStringFromClass([JSContact class]) Where:@"contactIdntifier = %@",sender.identifier].firstObject;
        ContactEditCoreDataViewController *contactDetailVC = [segue destinationViewController];
        contactDetailVC.contact = contact;
        contactDetailVC.screenMode = ScreemModeCoreDataEdit;
        [contactDetailVC addContactNumber:self.textFieldPhoneNumber.text];
        
    }
    
}

#pragma mark - Button Handler

- (IBAction)handlerAddContact:(id)sender {
    
    if (self.textFieldPhoneNumber.text.length>0) {
        contactPicker.delegate = self;
        contactPicker.displayedPropertyKeys = (NSArray *)CNContactGivenNameKey;
        
        [self presentViewController:contactPicker animated:YES completion:nil];
    }
    else{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Warning." message:@"Please enter phone number." preferredStyle:UIAlertControllerStyleAlert];
        
        [controller addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:controller animated:YES completion:nil];
    }
    
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:kSegueAddContacToEditContact sender:contact];
        self.textFieldPhoneNumber.text = @"";
    }];
}

@end
