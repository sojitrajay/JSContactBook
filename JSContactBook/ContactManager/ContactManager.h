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

typedef void (^JSContactManagerCompletion)(BOOL success, NSError *error);
typedef void (^JSContactManagerFetchContactsCompletion)(NSArray *arrayContacts, NSError *error);

@interface ContactManager : NSObject

+(ContactManager *)sharedContactManager;

@property (nonatomic) CNContactStore *store;
@property (nonatomic) NSMutableArray *arrayContacts;

- (void)requestContactManagerWithCompletion:(JSContactManagerCompletion)completion;

- (void)fetchContactsWithCompletion:(JSContactManagerFetchContactsCompletion)completion;

@end
