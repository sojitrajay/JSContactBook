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
#import "CNContact+JSContact.h"
#import "NSAttributedString+JSAttributedString.h"

@implementation JSContact

- (void)updateFromContact:(CNContact *)contact withContext:(NSManagedObjectContext*)context
{
    
    [self checkIfNewContact:contact ForContext:context];
    
    self.contactIdntifier = contact.identifier;
    
    self.givenName = contact.givenName;
    self.familyName = contact.familyName;
    self.displayName = contact.displayName.string;
    
    [self removeHas_phone_numbers:self.has_phone_numbers];
    [contact.phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue<CNPhoneNumber *> * _Nonnull phoneNumber, NSUInteger idx, BOOL * _Nonnull stop) {

        JSPhoneNumber *jsPhoneNumber = [context insertIntoEntity:NSStringFromClass([JSPhoneNumber class]) AgainstConditions:@"phoneNumberIdentifier = %@",phoneNumber.identifier];
        [jsPhoneNumber updateFromPhoneNumber:phoneNumber];
        jsPhoneNumber.belongs_to_contact = self;
        
    }];
    
}

/**
 * Manage History
 */

-(BOOL)checkIfNewContact:(CNContact*)contact ForContext:(NSManagedObjectContext*)context
{
    // If contacts are cached then only we need to load history.
    BOOL isContactCached = [[NSUserDefaults standardUserDefaults] boolForKey:kIsContactCached];
    if (isContactCached) {
        
        NSArray *arrayContacts = [context getDataForEntity:NSStringFromClass([JSContact class]) Where:@"contactIdntifier = %@",contact.identifier];
        NSInteger count = [context getAllDataForEntity:NSStringFromClass([JSContactHistory class])].count;

        if (arrayContacts.count<=0) {
            // Newly added contact
            JSContactHistory *conactEntity = [context insertIntoEntity:NSStringFromClass([JSContactHistory class])];
            conactEntity.historyId = (int32_t)count+1;
            conactEntity.contactId = contact.identifier;
            conactEntity.operation = kContactOperationAdd;
            conactEntity.fieldType = kFieldTypeContact;
            conactEntity.contactDisplayName = contact.displayName.string;
            return NO;
        }
        else
        {
            // Compare CNContact details with JSContact. And Id contact is updated then add a record to update contact.
            if ([self compareCNContact:contact withJSContact:arrayContacts.firstObject forContext:context]) {
                JSContactHistory *conactEntity = [context insertIntoEntity:NSStringFromClass([JSContactHistory class])];
                conactEntity.historyId = (int32_t)count+1;
                conactEntity.contactId = contact.identifier;
                conactEntity.operation = kContactOperationUpdated;
                conactEntity.fieldType = kFieldTypeContact;
                conactEntity.contactDisplayName = contact.displayName.string;
                return YES;
            }
        }
    }
    
    return NO;
}

/**
 * Compare CNContact with JSContact.
 */

- (BOOL)compareCNContact:(CNContact*)contact withJSContact:(JSContact*)jsContact forContext:(NSManagedObjectContext*)context
{
    NSLog(@"%@ %@",contact.familyName,contact.givenName);
    NSLog(@"%@ %@",jsContact.familyName,jsContact.givenName);

    if (![contact.familyName isEqualToString:jsContact.familyName]) {
        return YES;
    }
    if (![contact.givenName isEqualToString:jsContact.givenName]) {
        return YES;
    }
    if (![contact.displayName.string isEqualToString:jsContact.displayName]) {
        return YES;
    }
    
    __block BOOL isUpdatedPhoneNumber = NO;
    [jsContact.has_phone_numbers enumerateObjectsUsingBlock:^(JSPhoneNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        CNLabeledValue<CNPhoneNumber*> *phoneNumber = [contact.phoneNumbers where:@"identifier = %@",obj.phoneNumberIdentifier].firstObject;
        CNPhoneNumber *number = phoneNumber.value;
        NSString *label = [CNLabeledValue localizedStringForLabel:phoneNumber.label];
        
        if (![obj.label isEqualToString:label]) {
            isUpdatedPhoneNumber = YES;
        }
        if (![obj.phoneNumber isEqualToString:number.stringValue]) {
            isUpdatedPhoneNumber = YES;
        }
    }];
    
    return isUpdatedPhoneNumber;
}

/**
 * Updated Display Name;
 */
-(NSAttributedString*)displayNameAttributed
{
    NSDictionary *attributeNormalText = @{
                                          NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]],
                                          NSForegroundColorAttributeName:[UIColor blackColor]
                                          };
    NSMutableAttributedString *givenName   = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ ",self.givenName] attributes:attributeNormalText];
    
    NSDictionary *attributeBoldText = @{
                                        NSFontAttributeName:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]],
                                        NSForegroundColorAttributeName:[UIColor blackColor]
                                        };
    NSMutableAttributedString *familyName  = [[NSMutableAttributedString alloc]initWithString:self.familyName attributes:attributeBoldText];
    
    [givenName appendAttributedString:familyName];
    
    if ([givenName trimString].length>0) {
        return [givenName trimString];
    }
    else
    {
        NSDictionary *attributeItalicText = @{
                                              NSFontAttributeName:[UIFont italicSystemFontOfSize:[UIFont systemFontSize]],
                                              NSForegroundColorAttributeName:[UIColor blackColor]
                                              };
        NSMutableAttributedString *name  = [[NSMutableAttributedString alloc]initWithString:@"No Name" attributes:attributeItalicText];
        return name;
    }
    
}


@end
