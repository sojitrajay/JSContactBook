//
//  NSManagedObjectContext+QueryType.h
//  JSContactBook
//
//  Created by Jayesh on 09/08/17.
//  Copyright © 2017 Jayesh All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (QueryType)

-(NSArray *) getDataForEntity:(NSString *) entityName Where:(NSString *) condition, ...;
-(NSArray *) getDataForEntity:(NSString *) entityName WithSortingOn:(NSString *)sortField InAscendingOrder:(BOOL)inAscending Where:(NSString *) condition, ...;
-(NSArray *) getAllDataForEntity:(NSString *) entityName;
-(NSArray *) getAllDataForEntity:(NSString *) entityName WithSortingOn:(NSString *)sortField InAscendingOrder:(BOOL)inAscending;
-(__kindof NSManagedObject *) insertIntoEntity:(NSString *) entityName;
-(__kindof NSManagedObject *) insertIntoEntity:(NSString *) entityName AgainstConditions:(NSString *) condtions, ...;
-(BOOL) deleteAllRecordsForEntity:(NSString *) entityName;
-(BOOL) deleteRecordsForEntity:(NSString *)entityName Where:(NSString *) conditions, ...;
-(BOOL) commit;

@end
