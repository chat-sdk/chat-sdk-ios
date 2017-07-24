//
//  PUser.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 09/04/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BAccountTypes.h"

#import "BUserConnectionType.h"
#import "PElmUser.h"

@class RXPromise;
@protocol PUserConnection;
@protocol PThread;
@protocol PUserAccount;
@protocol PEntity;
@protocol PHasMeta;

@protocol PUser <PEntity, PHasMeta, PElmUser>

/**
 * @brief Sets the user's online status
 * @param online NSNumber(BOOL) is the user online or not
 */
-(void) setOnline: (NSNumber *) online;

/**
 * @brief Is the user currently connected to Firebase?
 * @return NSNumber(BOOL) user's online status
 */
-(NSNumber *) online;

/**
 * @brief User's large image - only ever seen by user
 * @para NSData Image in binary format
 */
-(void) setImage: (NSData *) image;

/**
 * @brief User's main image
 * @return NSData Image in binary format
 */
-(NSData *) image;
-(UIImage *) imageAsImage;
-(UIImage *) defaultImage;
-(NSString *) imageURL;

-(void) setThumbnail: (NSData *) image;
-(NSData *) thumbnail;
-(UIImage *) thumbnailAsImage;
-(void) setName: (NSString *) name;
-(NSString *) name;

-(void) setStatusDictionary: (NSDictionary *) dictionary;
-(NSDictionary *) getStatusDictionary;

-(void) setState: (NSString *) state;
-(NSString *) state;

-(void) setStatusText: (NSString *) statusText;
-(NSString *) statusText;

-(void) setMetaString: (NSString *) value forKey: (NSString *) key;
-(NSString *) metaStringForKey: (NSString *) key;

-(void) setMetaDictionary: (NSDictionary *) dict;
-(NSDictionary *) metaDictionary;

-(void) addContact: (id<PUser>) user;
-(NSArray *) getContacts;
-(void) setMetaValue: (id) value forKey: (NSString *) key;
-(id) metaValueForKey: (NSString *) key;

-(void) setMessageColor: (NSString *) color;
-(NSString *) messageColor;

-(void) setAuthenticationType: (NSString *) type;
-(NSString *) authenticationType;

-(RXPromise *) loadProfileImage: (BOOL) force;
-(RXPromise *) loadProfileThumbnail: (BOOL) force;

-(void) addLinkedAccountsObject: (id<PUserAccount>) account;

-(void) setEmail: (NSString *) email;
-(NSString *) email;

-(void) setPhoneNumber: (NSString *) phoneNumber;
-(NSString *) phoneNumber;

-(NSArray<PThread> *) threads;

-(int) unreadMessageCount;

-(NSString *) pushChannel;

-(id<PUserAccount>) accountWithType: (bAccountType) type;

-(id<PUser>) model;

-(NSArray<PUser> *) contactsWithType: (bUserConnectionType) type;
-(void) addConnection: (id<PUserConnection>) connection;
-(void) removeConnection: (id<PUserConnection>) connection;

-(NSArray<PUserConnection> *) connectionsWithType: (bUserConnectionType) type;

-(BOOL) isMe;


@end


