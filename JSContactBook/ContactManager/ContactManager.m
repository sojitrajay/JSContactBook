//
//  ContactManager.m
//  JSContactBook
//
//  Created by Jayesh on 8/2/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "ContactManager.h"

@implementation ContactManager

/**
 *  @author Jayesh Sojitra
 *
 *  Crates singleton object for Contact Manager Class.
 *
 *  @return Object of ContactManager.
 */
+(ContactManager *)sharedContactManager
{
    static ContactManager *_sharedObj = nil;
    static dispatch_once_t onceInstance;
    dispatch_once(&onceInstance, ^{
        _sharedObj = [[ContactManager alloc]init];
        
        _sharedObj.store            = [[CNContactStore alloc]init];
        _sharedObj.arrayContacts    = [[NSMutableArray alloc] init];
    });
    return _sharedObj;
}

/**
 *  @author Jayesh Sojitra
 *
 *  Request access to contact book to retrieve or manipulate contacts.
 *
 */
- (void)requestContactManagerWithCompletion:(JSContactManagerCompletion)completion
{
    [self.store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if (granted) {
            completion(YES, nil);
        }
        else
        {
            completion(NO, error);
        }
        
    }];
}

/**
 *  @author Jayesh Sojitra
 *
 *  This method is used to retrieve all contacts there is in the device.
 *
 */
-(void)fetchContactsWithCompletion:(JSContactManagerFetchContactsCompletion)completion
{
    [self.arrayContacts removeAllObjects];
    CNContactStore*  store = [[CNContactStore alloc]init];
    CNContactFetchRequest *fetchReq = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactIdentifierKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey, CNContactImageDataKey, CNContactViewController.descriptorForRequiredKeys]];
    
    fetchReq.sortOrder = CNContactSortOrderUserDefault;//For showing contact same as phonebook sorting
    
    NSError *error = nil;
    [store enumerateContactsWithFetchRequest:fetchReq error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL  *_Nonnull stop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.arrayContacts addObject:contact];
        });
    }];
    
    completion([self.arrayContacts mutableCopy],error);
    
}

@end
