//
//  PContactHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#ifndef PContactHandler_h
#define PContactHandler_h

#import <ChatSDKCore/BUserConnectionType.h>

typedef enum {
    bSearchTypeGoogle,
    bSearchTypeFacebook,
    bSearchTypePhonebook,
    bSearchTypeNameSearch,
} bSearchType;


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
-(NSArray<PUser> *) contactsWithType: (bUserConnectionType) type;
-(NSArray<PUserConnection> *) connectionsWithType: (bUserConnectionType) type;

/**
 * @brief Add a user to contacts
 */
-(RXPromise *) addContact: (id<PUser>) contact withType: (bUserConnectionType) type;

-(RXPromise *) deleteContact: (id<PUser>) user;

/**
 * Get the contact search view for a given search type
 */
-(RXPromise *) searchViewControllerForType: (bSearchType) type  exclude: (NSArray *) users usersAdded: (void(^)(NSArray * users)) usersAdded;

@end

#endif /* PContactHandler_h */
