//
//  JSContactHistory+CoreDataProperties.h
//  JSContactBook
//
//  Created by Jayesh on 09/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "JSContactHistory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface JSContactHistory (CoreDataProperties)

+ (NSFetchRequest<JSContactHistory *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *contactId;
@property (nullable, nonatomic, copy) NSString *fieldIdentifer;
@property (nullable, nonatomic, copy) NSString *fieldType;
@property (nonatomic) int32_t historyId;
@property (nullable, nonatomic, copy) NSString *oldData;
@property (nullable, nonatomic, copy) NSString *operation;
@property (nullable, nonatomic, copy) NSString *updatedData;

@end

NS_ASSUME_NONNULL_END
