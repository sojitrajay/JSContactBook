//
//  ContactManager.h
//  JSContactBook
//
//  Created by Jayesh on 8/2/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Contacts/CNContactStore.h>
#import <Contacts/CNContact.h>
#import <Contacts/CNContactFetchRequest.h>
#import <ContactsUI/CNContactViewController.h>

#import "CNContact+JSContact.h"

#import "CoreDataManager.h"

typedef void (^JSContactManagerCompletion)(BOOL success, NSError *error);
typedef void (^JSContactManagerFetchContactsCompletion)(NSArray *arrayContacts, NSError *error);
typedef void (^JSContactManagerUpdateContactsCompletion)(BOOL success, NSError *error);

@interface ContactManager : NSObject

+(ContactManager *)sharedContactManager;

@property (nonatomic) CNContactStore *store;
@property (nonatomic) NSMutableArray *arrayContacts;
@property (nonatomic) NSArray *keys;


- (void)requestContactManagerWithCompletion:(JSContactManagerCompletion)completion;

- (void)fetchContactsWithCompletion:(JSContactManagerFetchContactsCompletion)completion;

- (void)updateContact:(CNMutableContact*)mutableContact withCompletion:(JSContactManagerUpdateContactsCompletion)completion;

- (void)deleteContact:(CNMutableContact*)mutableContact withCompletion:(JSContactManagerUpdateContactsCompletion)completion;

- (void)addContact:(CNMutableContact*)mutableContact withCompletion:(JSContactManagerUpdateContactsCompletion)completion;

- (void)addOrUpdateContact:(CNMutableContact*)mutableContact withCompletion:(JSContactManagerUpdateContactsCompletion)completion;

- (BOOL)checkIfContactExist:(CNContact*)contact;

@end
