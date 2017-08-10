/*
 This makes some assumptions about your code, for example that you’ve got ownership rules set up properly. If a relationship to another entity uses the cascade deletion rule, it’s considered to be owned by the receiver, and thus will be copied by -deepCopyWithZone:.
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (RXCopying) <NSCopying>

-(void)setRelationshipsToObjectsByIDs:(id)objects;

-(id)deepCopyWithZone:(NSZone *)zone;
-(NSDictionary *)ownedIDs;

@end


@implementation NSManagedObject (RXCopying)

// copying
-(id)deepCopyWithZone:(NSZone *)zone {
    NSMutableDictionary *ownedIDs = [[self ownedIDs] mutableCopy];
    NSManagedObjectContext *context = [self managedObjectContext];
    id copied = [self copyWithZone: zone]; // -copyWithZone: copies the attributes for us
    
    for(NSManagedObjectID *key in [ownedIDs allKeys]) { // deep copy relationships
        id copiedObject = [[context objectWithID: key] copyWithZone: zone];
        [ownedIDs setObject: copiedObject forKey: key];
    }
    
    [copied setRelationshipsToObjectsByIDs: ownedIDs];
    for(NSManagedObjectID *key in [ownedIDs allKeys]) {
        [[ownedIDs objectForKey: key] setRelationshipsToObjectsByIDs: ownedIDs];
    }
    return copied;
}

-(id)copyWithZone:(NSZone *)zone { // shallow copy
    NSManagedObjectContext *context = [self managedObjectContext];
    id copied = [[[self class] allocWithZone: zone] initWithEntity: [self entity] insertIntoManagedObjectContext: context];
    
    for(NSString *key in [[[self entity] attributesByName] allKeys]) {
        [copied setValue: [self valueForKey: key] forKey: key];
    }
    
    for(NSString *key in [[[self entity] relationshipsByName] allKeys]) {
        [copied setValue: [self valueForKey: key] forKey: key];
    }
    return copied;
}

-(void)setRelationshipsToObjectsByIDs:(id)objects {
    id newReference = nil;
    NSDictionary *relationships = [[self entity] relationshipsByName];
    for(NSString *key in [relationships allKeys]) {
        if([[relationships objectForKey: key] isToMany]) {
            id references = [NSMutableSet set];
            for(id reference in [self valueForKey: key]) {
                if((newReference = [objects objectForKey: [reference objectID]])) {
                    [references addObject: newReference];
                } else {
                    [references addObject: reference];
                }
            }
            [self setValue: references forKey: key];
        } else {
            if((newReference = [objects objectForKey: [[self valueForKey: key] objectID]])) {
                [self setValue: newReference forKey: key];
            }
        }
    }
}

-(NSDictionary *)ownedIDs {
    NSDictionary *relationships = [[self entity] relationshipsByName];
    NSMutableDictionary *ownedIDs = [NSMutableDictionary dictionary];
    for(NSString *key in [relationships allKeys]) {
        id relationship = [relationships objectForKey: key];
        if([relationship deleteRule] == NSCascadeDeleteRule) { // ownership
            if([relationship isToMany]) {
                for(id child in [self valueForKey: key]) {
                    [ownedIDs setObject: child forKey: [child objectID]];
                    [ownedIDs addEntriesFromDictionary: [child ownedIDs]];
                }
            } else {
                id reference = [self valueForKey: key];
                [ownedIDs setObject: reference forKey: [reference objectID]];
            }
        }
    }
    return ownedIDs;
}

@end
