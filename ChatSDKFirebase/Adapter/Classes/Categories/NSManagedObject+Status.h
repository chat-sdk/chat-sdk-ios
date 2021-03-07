//
//  NSObject+Status.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 18/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (Status)

/**
 * @brief This allows us to add an is on property to a NSManagedObject. This is useful becuase we don't want
 * to add multiple firebase observers to an object. Since the object wrapper is disposable we need to add an
 * is on property to the managed object
 */
-(void) setOn: (BOOL) isOn;
-(BOOL) on;

-(void) setMessagesOn:(BOOL)isOn;
-(BOOL) messagesOn;

-(void) setMetaOn:(BOOL)isOn;
-(BOOL) metaOn;

-(void) setOnlineOn:(BOOL)isOn;
-(BOOL) onlineOn;

-(void) setPath: (NSString *) path on: (BOOL) on;
-(BOOL) pathOn: (NSString *) path;

@end
