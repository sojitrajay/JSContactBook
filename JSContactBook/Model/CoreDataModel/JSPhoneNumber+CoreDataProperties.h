//
//  JSPhoneNumber+CoreDataProperties.h
//  JSContactBook
//
//  Created by Jayesh on 09/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "JSPhoneNumber+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface JSPhoneNumber (CoreDataProperties)

+ (NSFetchRequest<JSPhoneNumber *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *label;
@property (nullable, nonatomic, copy) NSString *phoneNumber;
@property (nullable, nonatomic, copy) NSString *phoneNumberIdentifier;
@property (nullable, nonatomic, retain) JSContact *belongs_to_contact;

@end

NS_ASSUME_NONNULL_END
