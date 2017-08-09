//
//  NSManagedObjectContext+QueryType.m
//  JSContactBook
//
//  Created by Jayesh on 09/08/17.
//  Copyright © 2017 Jayesh All rights reserved.
//

#import "NSManagedObjectContext+QueryType.h"

@implementation NSManagedObjectContext (QueryType)

/**
 *  @author Jayesh Sojitra
 *
 *  Fetch records from coredata managedobjectcontext that satisfy the condition given by user as where clause.
 *
 *  @param entityName NSString that indicates name of entity for which you want to fetch a data.
 *  @param condition  NSString that contains where clause that needs to satify.
 *
 *  @return NSArray that contains list of records.
 */
-(NSArray *) getDataForEntity:(NSString *) entityName Where:(NSString *) condition, ...{
    
    va_list args;
    va_start(args, condition);
    
    NSPredicate *predicate =  [self PredicateCondition:condition withArgs:args];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPredicate:predicate];
    [request setReturnsObjectsAsFaults:NO];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [self executeFetchRequest:request error:&error];
    
    if (error)
    {
        //NSLog(@"CoreDataManager_fetchLoggedUserInquiryList_Fetching inquiry failed: %@", error);
    }
    va_end(args);
    
    if ([array count] > 0) {
        return array;
    }
    else{
        array = [NSArray new];
    }
    
    return array;
    
}

-(NSArray *) getDataForEntity:(NSString *) entityName WithSortingOn:(NSString *)sortField InAscendingOrder:(BOOL)inAscending Where:(NSString *) condition, ...{
    
    va_list args;
    va_start(args, condition);
    
    NSPredicate *predicate =  [self PredicateCondition:condition withArgs:args];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:sortField ascending:inAscending selector:@selector(localizedStandardCompare:)];

    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPredicate:predicate];
    [request setReturnsObjectsAsFaults:NO];
    [request setEntity:entityDescription];
    [request setSortDescriptors:@[sortDescriptor]];

    NSError *error;
    NSArray *array = [self executeFetchRequest:request error:&error];
    
    if (error)
    {
        //NSLog(@"CoreDataManager_fetchLoggedUserInquiryList_Fetching inquiry failed: %@", error);
    }
    va_end(args);
    
    if ([array count] > 0) {
        return array;
    }
    else{
        array = [NSArray new];
    }
    
    return array;
    
}

/**
 *  @author Jayesh Sojitra
 *
 *  Create predicate for given condtions because coredata understand the conditions in NSPredicate format.
 *
 *  @param condition NSString that contains where conditions.
 *  @param args      List argument that contains values that replaces the specifires in Condition.
 *
 *  @return NSPredicate
 */
-(NSPredicate *) PredicateCondition:(NSString*)condition withArgs:(va_list)args
{
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:condition arguments:args];
    
    return predicate;
}

/**
 *  @author Jayesh Sojitra
 *
 *  Fetch records from coredata managedobjectcontext that satisfy the condition given by user as where clause.
 *
 *  @param entityName NSString that indicates name of entity for which you want to fetch a data.
 *
 *  @return NSArray that contains list of records.
 */
-(NSArray *) getAllDataForEntity:(NSString *) entityName{
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [self executeFetchRequest:request error:&error];
    
    if (error)
    {
        //NSLog(@"CoreDataManager_fetchLoggedUserInquiryList_Fetching inquiry failed: %@", error);
    }
    
    return array;
}


-(NSArray *) getAllDataForEntity:(NSString *) entityName WithSortingOn:(NSString *)sortField InAscendingOrder:(BOOL)inAscending {
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:sortField ascending:inAscending selector:@selector(localizedStandardCompare:)];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    [request setEntity:entityDescription];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [self executeFetchRequest:request error:&error];
    
    if (error)
    {
        //NSLog(@"CoreDataManager_fetchLoggedUserInquiryList_Fetching inquiry failed: %@", error);
    }
    
    return array;
}

/**
 *  @author Jayesh Sojitra
 *
 *  Inserts new records for coredata entity.
 *
 *  @param entityName NSString that contains name of entity.
 *
 *  @return NSMangedObject that created.
 */
-(__kindof NSManagedObject *) insertIntoEntity:(NSString *) entityName{
    
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
    
    return managedObject;
}

/**
 *  @author Jayesh Sojitra
 *
 *  Check that the object user wants to insert into coredata is already exist or not if exist then we need to insert into coredata other wise insert new record for entity.
 *
 *  @param entityName NSString contains name of entity to insert into coredata.
 *  @param condtions  NSString contains primary key kind of condition which checks that record alrady presented or not.
 *
 *  @return NSManageObject of destination type.
 */
-(__kindof NSManagedObject *) insertIntoEntity:(NSString *) entityName AgainstConditions:(NSString *) condtions, ...{
    
    va_list args;
    va_start(args, condtions);
    
    NSPredicate *predicate =  [self PredicateCondition:condtions withArgs:args];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPredicate:predicate];
    [request setReturnsObjectsAsFaults:NO];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [self executeFetchRequest:request error:&error];
    
    NSManagedObject *managedObject;
    
    if([array count] > 0){
        
        managedObject = [array lastObject];
    }
    else{
        
        managedObject = [self insertIntoEntity:entityName];
    }
    
    return managedObject;
}


/**
 *  @author Jayesh Sojitra
 *
 *  Delete all records for entity specified by user.
 *
 *  @param entityName NSString contains name of coredata entity whose data needs to be delete.
 *
 *  @return BOOL value determines that records deleted successfully or not.
 */
-(BOOL) deleteAllRecordsForEntity:(NSString *) entityName{
    
    NSArray *array = [self getAllDataForEntity:entityName];
    
    for (NSManagedObject *object in array) {
        [self deleteObject:object];
    }
    
    return [self commit];
}

/**
 *  @author Jayesh Sojitra
 *
 *  Delete all records for entity which satify given conditions.
 *
 *  @param entityName NSString contains name of coredata entity whose data needs to be delete.
 *  @param conditions NSString contains conditions which will be used to create NSPredicate.
 *
 *  @return BOOL value determines that records deleted successfully or not.
 */
-(BOOL) deleteRecordsForEntity:(NSString *)entityName Where:(NSString *) conditions, ...{
    
    va_list args;
    va_start(args, conditions);
    
    NSPredicate *predicate =  [self PredicateCondition:conditions withArgs:args];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPredicate:predicate];
    [request setReturnsObjectsAsFaults:NO];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [self executeFetchRequest:request error:&error];
    va_end(args);
    
    for (NSManagedObject *object in array) {
        [self deleteObject:object];
    }
    
    return [self commit];
}

/**
 *  @author Jayesh Sojitra
 *
 *  Save All data for current context to persistent store coordinator.
 *
 *  @return BOOL value determines that data saved to persistent store successfully or not.
 */
-(BOOL) commit{
    
    NSError *error;
    
    [self save:&error];
    
    if (error) {
        return NO;
    }
    else{
        return YES;
    }
    
}

@end
