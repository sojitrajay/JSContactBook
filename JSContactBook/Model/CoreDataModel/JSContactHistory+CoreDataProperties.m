//
//  JSContactHistory+CoreDataProperties.m
//  JSContactBook
//
//  Created by Jayesh on 09/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "JSContactHistory+CoreDataProperties.h"

@implementation JSContactHistory (CoreDataProperties)

+ (NSFetchRequest<JSContactHistory *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"JSContactHistory"];
}

@dynamic contactId;
@dynamic fieldIdentifer;
@dynamic fieldType;
@dynamic historyId;
@dynamic oldData;
@dynamic operation;
@dynamic contactDisplayName;

@end
