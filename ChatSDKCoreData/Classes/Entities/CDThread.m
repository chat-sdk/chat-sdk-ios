//
//  CDThread.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import "CDThread.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/CoreData.h>
#import <ChatSDK/ChatSDK-Swift.h>

@implementation CDThread

-(instancetype) init {
    if((self = [super init])) {
    }
    return self;
}

- (void)reverse: (NSMutableArray *) array {
    [self checkOnMain];
    
    if ([array count] <= 1)
        return;
    NSUInteger i = 0;
    NSUInteger j = [array count] - 1;
    while (i < j) {
        [array exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

-(NSArray *) allMessages {
    [self checkOnMain];
    return self.messages.allObjects;
}

-(BOOL) hasMessages {
    [self checkOnMain];
    return self.newestMessage != nil;
}

-(void) addMessage: (id<PMessage>) theMessage {
    [self addMessage:theMessage toStart:NO];
}

-(void) addMessageAndSort: (id<PMessage>) theMessage {
    // Check if the message has already been added
    CDMessage * message = (CDMessage *) theMessage;

    if ([self containsMessage:message]) {
        return;
    }
    message.thread = self;
    NSArray * messages = [BChatSDK.db loadMessagesForThread:self oldest:NSIntegerMax];
    
    int index = [messages indexOfObject:message];
    if (index > 0) {
        CDMessage * previous = messages[index - 1];
        message.previousMessage = previous;
        previous.nextMessage = message;
        [previous updatePosition];
    }
    if(index < messages.count - 1) {
        CDMessage * next = messages[index + 1];
        message.nextMessage = next;
        next.previousMessage = message;
        [next updatePosition];
    }
    [message updatePosition];
    
    //    NSArray * messages = [BChatSDK.db loadMessagesForThread:self newest:1];
    //    if (messages.count) {
    //        return messages.firstObject;
    //    }

    self.newestMessage = messages.lastObject;
    
}

-(void) addMessage: (id<PMessage>) theMessage toStart: (BOOL) toStart {
    [self checkOnMain];
    CDMessage * message = (CDMessage *) theMessage;
    
    // Check if the message has already been added
    if ([self containsMessage:message]) {
        return;
    }

    if (toStart) {
        // Set the last message for this message
        CDMessage * oldestMessage = (CDMessage *) self.oldestMessage;
        if (oldestMessage) {
            message.nextMessage = oldestMessage;
            oldestMessage.previousMessage = message;
        } else {
            // if this is the first message...
            self.newestMessage = theMessage;
        }
    } else {
        // Set the last message for this message
        CDMessage * newestMessage = (CDMessage *) self.newestMessage;
        if (newestMessage) {
            message.previousMessage = newestMessage;
            newestMessage.nextMessage = message;
        }
        self.newestMessage = message;
    }
    
    // Add the message to the thread
    message.thread = self;
    
    if (message.nextMessage) {
        [message.nextMessage updatePosition];
    }
    if(message.previousMessage) {
        [message.previousMessage updatePosition];
    }
    [message updatePosition];
    
    if (BChatSDK.config.debugModeEnabled) {
        [BCoreUtilities checkDuplicateThread];
        [BCoreUtilities checkOnMain];
    }

}
//
//-(id<PMessage>) newestMessage {
//    [self checkOnMain];
//    
//    [self willAccessValueForKey:NSStringFromSelector(_cmd)];
//    CDMessage * message = [self primativeNewestMessage];
//    [self didAccessValueForKey:NSStringFromSelector(_cmd)];
//
//    if (!message) {
//        NSArray * messages = [BChatSDK.db loadMessagesForThread:self newest:1];
//        if (messages.count) {
//            [self setNewestMessage:messages.firstObject];
//        }
//    }
//    
//    return message;
//}

-(id<PMessage>) oldestMessage {
    [self checkOnMain];
    NSArray * messages = [BChatSDK.db loadMessagesForThread:self oldest:1];
    if (messages.count) {
        return messages.firstObject;
    }
    return Nil;
}
-(void) removeMessage: (id<PMessage>) theMessage {
    [self checkOnMain];
    CDMessage * message = (CDMessage *) theMessage;
    
    CDMessage * previousMessage = message.previousMessage;
    CDMessage * nextMessage = message.nextMessage;

    if (previousMessage) {
        previousMessage.nextMessage = message.nextMessage;
        [previousMessage updatePosition];
    }
    if (nextMessage) {
        nextMessage.previousMessage = previousMessage;
        [nextMessage updatePosition];
    }

    message.thread = Nil;
    [BChatSDK.db deleteEntity:message];
    
    self.newestMessage = [[self messagesOrderedByDateNewestFirst] firstObject];
}

-(NSArray *) orderMessagesByDateAsc: (NSArray *) messages {
    [self checkOnMain];
    return [messages sortedArrayUsingComparator:^(id<PMessage> m1, id<PMessage> m2) {
        return [m1.date compare:m2.date];
    }];
}

-(NSArray *) messagesOrderedByDateAsc {
    return [self messagesOrderedByDateOldestFirst];
}

-(NSArray *) messagesOrderedByDateNewestFirst {
    return [BChatSDK.db loadAllMessagesForThread:self newestFirst:YES];
}

-(NSArray *) messagesOrderedByDateOldestFirst {
    return [BChatSDK.db loadAllMessagesForThread:self newestFirst:NO];
}

-(NSArray *) messagesOrderedByDateDesc {
    return [self messagesOrderedByDateNewestFirst];
}

-(NSArray *) orderMessagesByDateDesc: (NSArray *) messages {
    [self checkOnMain];
    return [messages sortedArrayUsingComparator:^(id<PMessage> m1, id<PMessage> m2) {
        return [m2.date compare:m1.date];
    }];
}

-(NSString *) displayName {
    [self checkOnMain];
    if (self.type.intValue & bThreadFilterPrivate) {
        
        if (self.name && self.name.length) {
            return self.name;
        }
        
        return self.memberListString;
    }
    if (self.type.intValue & bThreadFilterPublic) {
        return self.name;
    }
    return Nil;
}

-(NSString *) memberListString {
    [self checkOnMain];
    NSString * name = @"";
    
    for (id<PUser> user in self.members) {
        if (!user.isMe) {
            CDUserConnection * connection = [self connection:user.entityID];
            if (connection && connection.affiliation.isOutcast) {
                continue;
            }
            if (user.name.length) {
                name = [name stringByAppendingFormat:@"%@, ", user.name];
            }
        }
    }
    
    if (name.length > 2) {
        return [name substringToIndex:name.length - 2];
    }
    return Nil;
}

-(NSArray<PUser> *) members {
    NSMutableArray * members = [NSMutableArray new];
    for (id<PUser> user in self.users) {
        CDUserConnection * connection = [self connection:user.entityID];
        if (connection && (connection.hasLeft || connection.affiliation.isOutcast)) {
            continue;
        }
        [members addObject:user];
    }
    return members;
    
}

-(void) markRead {
    [self checkOnMain];

    BOOL didMarkRead = NO;
    
    NSArray<PMessage> * messages = [BChatSDK.db loadAllMessagesForThread:self newestFirst:YES];
    for(id<PMessage> message in messages) {
        if (!message.isRead && !message.senderIsMe) {
            [message setDelivered: @YES];
            [message setRead: @YES];
            
            // TODO: Should we have this here? Maybe this gets called too soon
            // but it's a good backup in case the app closes before we save
            didMarkRead = YES;
        }
    }
    if (didMarkRead) {
        [BHookNotification notificationThreadMarkedRead:self];
    }
}

-(int) unreadMessageCount {
    return [BChatSDK.db unreadMessagesCountNow:self.entityID];
}

-(id<PThread>) model {
    return self;
}

-(BOOL) addUser: (id<PUser>) user {
    [self checkOnMain];
    @synchronized (self) {
        if ([user isKindOfClass:[CDUser class]]) {
            if (![self containsUser:user]) {
                [self addUsersObject:(CDUser *)user];
                [self addConnection:user];
                return YES;
            }
        }
        return NO;
    }
}

-(BOOL) addConnection: (id<PUser>) user {
    @synchronized (self) {
        if (![self connection:user.entityID]) {
            CDUserConnection * connection = [BChatSDK.db fetchOrCreateUserConnectionWithID:user.entityID withType:bUserConnectionTypeMember];
            [self addUserConnectionsObject:connection];
            return YES;
        }
        return NO;
    }
}

-(BOOL) removeConnection: (id<PUser>) user {
    CDUserConnection * connection = [self connection:user.entityID];
    if (connection) {
        [self removeUserConnectionsObject:connection];
        [BChatSDK.db deleteEntity:connection];
        return YES;
    }
    return NO;
}

-(NSArray<id<PUserConnection>> *) connections {
    return self.userConnections;
}

-(id<PUserConnection>) connection: (NSString *) entityID {
    [self checkOnMain];
    for (id<PUserConnection> u in self.userConnections) {
        if ([u.entityID isEqualToString: entityID]) {
            return u;
        }
    }
    return nil;
}

- (BOOL) removeUser:(id<PUser>) user {
    [self checkOnMain];
    if ([user isKindOfClass:[CDUser class]]) {
        if ([self containsUser: user]) {
            [self removeUsersObject:(CDUser *) user];
            [self removeConnection:user];
            return YES;
        }
    }
    return NO;
}

-(BOOL) containsUser: (id<PUser>) user {
    [self checkOnMain];
    
    for (id<PUser> u in self.users) {
        if ([u.entityID isEqualToString:user.entityID]) {
            return true;
        }
    }
    
    // Check connections too
    return [self connection:user.entityID] != nil;
}

-(BOOL) containsMessage: (id<PMessage>) message {
    [self checkOnMain];
    for (id<PMessage> m in self.messages) {
        if ([m.entityID isEqualToString:message.entityID]) {
            return true;
        }
    }
    return false;
}
-(id<PUser>) otherUser {
    [self checkOnMain];
    id<PUser> currentUser = BChatSDK.currentUser;
    if (self.type.intValue == bThreadType1to1 || self.users.count == 2) {
        for (id<PUser> user in self.users) {
            if (!user.isMe) {
                return user;
            }
        }
    }
    return Nil;
}

-(void) updateMeta: (NSDictionary *) dict {
    [self checkOnMain];
    if (!self.meta) {
        self.meta = @{};
    }
    self.meta = [self.meta updateMetaDict:dict];
}

-(void) setMetaValue: (id) value forKey: (NSString *) key {
    [self updateMeta:@{key: [NSString safe: value]}];
}

-(void) removeMetaValueForKey: (NSString *) key {
    [self checkOnMain];
    NSMutableDictionary * newMeta = [NSMutableDictionary dictionaryWithDictionary:self.meta];
    [newMeta removeObjectForKey:key];
    self.meta = newMeta;
}

-(NSDate *) orderDate {
    [self checkOnMain];

    id<PMessage> message = self.newestMessage;
    if (message) {
        return message.date;
    }
    else {
        return self.creationDate;
    }
}

-(BOOL) isEqualToEntity: (id<PEntity>) entity {
    [self checkOnMain];
    return [self.entityID isEqualToString:entity.entityID];
}

-(BOOL) isReadOnly {
    [self checkOnMain];
    id readOnly = self.meta[bReadOnly];
    if (readOnly) {
        if([readOnly isKindOfClass:NSNumber.class]) {
            return [readOnly boolValue];
        }
        // Deprecated, only for backwards compatibility
        if([readOnly isKindOfClass:NSString.class]) {
            return true;
        }
    }
    return false;
}

-(BOOL) typeIs: (bThreadType) type {
    return self.type.intValue & type;
}

-(NSString *) imageURL {
    NSString * url = [self.meta metaValueForKey:bImageURL];
    if ((!url || !url.length) && ([self typeIs:bThreadType1to1] || self.users.count == 2)) {
        return self.otherUser.imageURL;
    }
    return url;
}

@end
