//
//  CoreDataManager.h
//  JSContactBook
//
//  Created by Jayesh on 09/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataConstant.h"
#import "NSManagedObjectContext+Queryable.h"
#import "NSManagedObjectContext+QueryType.h"
#import "NSArray+Uitlity.h"

#import "JSContact+CoreDataClass.h"
#import "JSPhoneNumber+CoreDataClass.h"
#import "JSContactHistory+CoreDataClass.h"

@interface CoreDataManager : NSObject

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;

+ (CoreDataManager*)sharedCoreData;

@end
