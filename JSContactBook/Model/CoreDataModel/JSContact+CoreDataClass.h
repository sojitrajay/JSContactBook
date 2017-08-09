//
//  JSContact+CoreDataClass.h
//  
//
//  Created by Jayesh on 09/08/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Contacts/CNContact.h>

@class JSPhoneNumber;

NS_ASSUME_NONNULL_BEGIN

@interface JSContact : NSManagedObject

- (void)updateFromContact:(CNContact *)contact withContext:(NSManagedObjectContext*)context;

@end

NS_ASSUME_NONNULL_END

#import "JSContact+CoreDataProperties.h"
