//
//  PContactHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#ifndef PContactHandler_h
#define PContactHandler_h

#import <ChatSDK/BUserConnectionType.h>

#define bSearchTypeGoogle @"Google"
#define bSearchTypeFacebook @"Facebook"
#define bSearchTypeNameSearch @"NameSearch"

@class RXPromise;

@protocol PUser;
@protocol PUserConnection;

@protocol PContactHandler <NSObject>

/**
 * @brief Get a list of the user's contacts
 */
-(NSArray *) contacts;

/**
 * @brief Get a list of the user's contacts
 */
-(NSArray *) contactsWithType: (bUserConnectionType) type;
-(NSArray *) connectionsWithType: (bUserConnectionType) type;

/**
 * @brief Add a user to contacts
 */
-(RXPromise *) addContact: (id<PUser>) contact withType: (bUserConnectionType) type;
-(RXPromise *) addLocalContact: (id<PUser>) contact withType: (bUserConnectionType) type;
-(RXPromise *) deleteContact: (id<PUser>) user withType: (bUserConnectionType) type;
-(RXPromise *) deleteLocalContact: (id<PUser>) user withType: (bUserConnectionType) type;

@end

#endif /* PContactHandler_h */
