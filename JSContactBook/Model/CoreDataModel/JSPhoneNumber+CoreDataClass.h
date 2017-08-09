//
//  JSPhoneNumber+CoreDataClass.h
//  
//
//  Created by Jayesh on 09/08/17.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Contacts/CNPhoneNumber.h>
#import <Contacts/CNLabeledValue.h>

@class JSContact;

NS_ASSUME_NONNULL_BEGIN

@interface JSPhoneNumber : NSManagedObject

- (void)updateFromPhoneNumber:(CNLabeledValue<CNPhoneNumber *> * _Nonnull) phoneNumber;

@end

NS_ASSUME_NONNULL_END

#import "JSPhoneNumber+CoreDataProperties.h"
