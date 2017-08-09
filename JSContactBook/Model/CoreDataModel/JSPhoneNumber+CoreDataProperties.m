//
//  JSPhoneNumber+CoreDataProperties.m
//  JSContactBook
//
//  Created by Jayesh on 09/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "JSPhoneNumber+CoreDataProperties.h"

@implementation JSPhoneNumber (CoreDataProperties)

+ (NSFetchRequest<JSPhoneNumber *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"JSPhoneNumber"];
}

@dynamic label;
@dynamic phoneNumber;
@dynamic phoneNumberIdentifier;
@dynamic belongs_to_contact;

@end
