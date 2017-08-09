//
//  CoreDataConstant.h
//  JSContactBook
//
//  Created by Jayesh on 09/08/17.
//  Copyright © 2017 Jayesh. All rights reserved.
//

#ifndef CoreDataConstant_h
#define CoreDataConstant_h

#import <Foundation/Foundation.h>

#import "AppDelegate.h"

#define kAppDelegate                    ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define kIsContactCached            @"IsContactCached"

#define kContactOperationAdd        @"Add"
#define kContactOperationUpdated    @"Updated"
#define kContactOperationDeleted    @"Deleted"

#define kFieldTypeContact           @"Contact"
#define kFieldTypePhoneNumber       @"PhoneNumber"

#endif /* CoreDataConstant_h */
