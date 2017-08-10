/*
This makes some assumptions about your code, for example that you’ve got ownership rules set up properly. If a relationship to another entity uses the cascade deletion rule, it’s considered to be owned by the receiver, and thus will be copied by -deepCopyWithZone:.
*/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (RXCopying)


// copying
-(id)deepCopyWithZone:(NSZone *)zone;

-(id)copyWithZone:(NSZone *)zone;

-(void)setRelationshipsToObjectsByIDs:(id)objects;

-(NSDictionary *)ownedIDs;


@end
