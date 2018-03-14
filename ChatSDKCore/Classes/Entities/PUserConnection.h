//
//  PLinkedContact.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 26/11/2015.
//
//

#ifndef PUserConnection_h
#define PUserConnection_h

#import <ChatSDK/bSubscriptionType.h>
#import <ChatSDK/BUserConnectionType.h>
#import <ChatSDK/PHasMeta.h>

@protocol PUser;
@protocol PGroup;

@protocol PUserConnection<NSObject, PHasMeta>

-(NSString *) entityID;
-(void) setEntityID: (NSString *) entityID;

-(id<PUser>) owner;

-(NSNumber *) type;
-(void) setType: (NSNumber *) type;
-(bUserConnectionType) userConnectionType;

-(id) metaValueForKey: (NSString *) key;
-(void) setMetaValue: (id) value forKey: (NSString *) key;

-(NSSet *) groups;
-(void) addGroupsObject: (id<PGroup>) group;

-(id<PUser>) user;

-(void) setSubscriptionType: (NSString *) subscriptionType;
-(bSubscriptionType) subscriptionType;

@end

#endif /* PUserConnection_h */
