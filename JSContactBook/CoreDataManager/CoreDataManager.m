//
//  CoreDataManager.m
//  JSContactBook
//
//  Created by Jayesh on 09/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

/**
 *  @author Jayesh
 *
 *  Crates singleton object of CoreDataManager.
 *
 *  @return Object of CoreDataManagerClass.
 */
+(CoreDataManager *)sharedCoreData
{
    static CoreDataManager *_sharedObj = nil;
    static dispatch_once_t onceInstance;
    dispatch_once(&onceInstance, ^{
        _sharedObj = [[CoreDataManager alloc]init];
    });
    return _sharedObj;
}

/**
 *  @author Jayesh
 *
 *  Intializer CoreDataManager.
 *
 *  @return Instance of CoreDataManager.
 */
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.managedObjectContext = kAppDelegate.persistentContainer.viewContext;
    }
    return self;
}


@end
