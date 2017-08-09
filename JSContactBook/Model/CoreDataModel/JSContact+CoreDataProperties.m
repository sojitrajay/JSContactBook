//
//  JSContact+CoreDataProperties.m
//  JSContactBook
//
//  Created by Jayesh on 09/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "JSContact+CoreDataProperties.h"

@implementation JSContact (CoreDataProperties)

+ (NSFetchRequest<JSContact *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"JSContact"];
}

@dynamic contactId;
@dynamic contactIdntifier;
@dynamic familyName;
@dynamic givenName;
@dynamic displayName;
@dynamic has_phone_numbers;

@end
