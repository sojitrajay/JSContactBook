//
//  JSContact+CoreDataProperties.h
//  JSContactBook
//
//  Created by Jayesh on 09/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "JSContact+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface JSContact (CoreDataProperties)

+ (NSFetchRequest<JSContact *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *contactId;
@property (nullable, nonatomic, copy) NSString *contactIdntifier;
@property (nullable, nonatomic, copy) NSString *familyName;
@property (nullable, nonatomic, copy) NSString *givenName;
@property (nullable, nonatomic, copy) NSString *displayName;
@property (nullable, nonatomic, retain) NSSet<JSPhoneNumber *> *has_phone_numbers;

@end

@interface JSContact (CoreDataGeneratedAccessors)

- (void)addHas_phone_numbersObject:(JSPhoneNumber *)value;
- (void)removeHas_phone_numbersObject:(JSPhoneNumber *)value;
- (void)addHas_phone_numbers:(NSSet<JSPhoneNumber *> *)values;
- (void)removeHas_phone_numbers:(NSSet<JSPhoneNumber *> *)values;

@end

NS_ASSUME_NONNULL_END
