//
//  JSContact+CoreDataClass.m
//  
//
//  Created by Jayesh on 09/08/17.
//
//

#import "JSContact+CoreDataClass.h"
#import "JSPhoneNumber+CoreDataClass.h"
#import "CoreDataManager.h"

@implementation JSContact

- (void)updateFromContact:(CNContact *)contact withContext:(NSManagedObjectContext*)context checkForUpdate:(BOOL)checkForUpdate
{
    self.contactIdntifier = contact.identifier;
    
    self.givenName = contact.givenName;
    self.familyName = contact.familyName;
    
    [contact.phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue<CNPhoneNumber *> * _Nonnull phoneNumber, NSUInteger idx, BOOL * _Nonnull stop) {

        JSPhoneNumber *jsPhoneNumber = [context insertIntoEntity:NSStringFromClass([JSPhoneNumber class]) AgainstConditions:@"phoneNumberIdentifier = %@",phoneNumber.identifier];
        [jsPhoneNumber updateFromPhoneNumber:phoneNumber];
        jsPhoneNumber.belongs_to_contact = self;
        
    }];
    
}

@end
