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

@implementation CDThread

-(instancetype) init {
    if((self = [super init])) {
    }
    return self;
}

- (void)reverse: (NSMutableArray *) array {
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
    return self.messages.allObjects;
}

-(BOOL) hasMessages {
    return self.newestMessage != Nil;
}

-(void) addMessage: (id<PMessage>) theMessage {
    [self addMessage:theMessage toStart:NO];
}

-(void) addMessage: (id<PMessage>) theMessage toStart: (BOOL) toStart {
    CDMessage * message = (CDMessage *) theMessage;
    
    // Check if the message has already been added
    if ([self.messages containsObject:message]) {
        return;
    }

    if (toStart) {
        // Set the last message for this message
        CDMessage * oldestMessage = (CDMessage *) self.oldestMessage;
        if (oldestMessage) {
            message.nextMessage = oldestMessage;
            oldestMessage.previousMessage = message;
        }
    } else {
        // Set the last message for this message
        CDMessage * newestMessage = (CDMessage *) self.newestMessage;
        if (newestMessage) {
            message.previousMessage = newestMessage;
            newestMessage.nextMessage = message;
        }
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
}

-(id<PMessage>) newestMessage {
    NSArray * messages = [BChatSDK.db loadMessagesForThread:self newest:1];
    if (messages.count) {
        return messages.firstObject;
    }
    return Nil;
}

-(id<PMessage>) oldestMessage {
    NSArray * messages = [BChatSDK.db loadMessagesForThread:self oldest:1];
    if (messages.count) {
        return messages.firstObject;
    }
    return Nil;
}
-(void) removeMessage: (id<PMessage>) theMessage {
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
}

-(NSArray *) orderMessagesByDateAsc: (NSArray *) messages {
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
    return [messages sortedArrayUsingComparator:^(id<PMessage> m1, id<PMessage> m2) {
        return [m2.date compare:m1.date];
    }];
}

-(NSString *) displayName {
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
    NSString * name = @"";
    
    for (id<PUser> user in self.users) {
        if (!user.isMe) {
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

-(void) markRead {
    
    BOOL didMarkRead = NO;
    
    for(id<PMessage> message in self.messages) {
        if (!message.isRead && !message.senderIsMe) {
            [message setRead: @YES];
            
            // TODO: Should we have this here? Maybe this gets called too soon
            // but it's a good backup in case the app closes before we save
            [message setDelivered: @YES];
            didMarkRead = YES;
        }
    }
    if (didMarkRead) {
        [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationThreadRead object:Nil];
    }
}

-(int) unreadMessageCount {
    int i = 0;
    NSArray<PMessage> * messages = [BChatSDK.db loadAllMessagesForThread:self newestFirst:YES];
    for (id<PMessage> message in messages) {
        if (!message.isRead && !message.senderIsMe) {
            i++;
        }
    }
    return i;
}

-(id<PThread>) model {
    return self;
}

-(void) addUser: (id<PUser>) user {
    if ([user isKindOfClass:[CDUser class]]) {
        if (![self.users containsObject:(CDUser *)user]) {
            [self addUsersObject:(CDUser *)user];
        }
    }
}

- (void)removeUser:(id<PUser>) user {
    if ([user isKindOfClass:[CDUser class]]) {
        if ([self.users containsObject:(CDUser *)user]) {
            [self removeUsersObject:(CDUser *) user];
        }
    }
}

-(id<PUser>) otherUser {
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
    if (!self.meta) {
        self.meta = @{};
    }
    self.meta = [self.meta updateMetaDict:dict];
}

-(void) setMetaValue: (id) value forKey: (NSString *) key {
    [self updateMeta:@{key: [NSString safe: value]}];
}

// TODO: Move this to UI module
-(RXPromise *) imageForThread {

    NSMutableArray * userPromises = [NSMutableArray new];
    NSMutableArray * users = [NSMutableArray arrayWithArray:self.users.allObjects];
    for (id<PUser> user in users) {
        if (!user.image && !user.isMe) {
            [userPromises addObject:user.updateAvatarFromURL];
        }
    }
    
    return [RXPromise all:userPromises].thenOnMain(^id(id result) {
        return self.buildImageForThread;
    }, Nil);
}

- (UIImage *) buildImageForThread {
    NSMutableArray * users = [NSMutableArray arrayWithArray:self.users.allObjects];
    
    // Remove the current user from the array
    [users removeObject:BChatSDK.currentUser];
    
    // Create a temporary array as we cannot loop through an array and remove users
    NSMutableArray * tempUsers = [NSMutableArray arrayWithArray:users];
    
    // We want to remove any users who have the automatic profile picture
    for (id<PUser> user in tempUsers) {
        
        // Check if the user picture has been uploaded
        if (!user.image) {
            [users removeObject:user];
        }
    }
    
    // If users array empty then just return the defaut picture
    if (!users.count) {
        
        // Check how many users are in the conversation
        if (self.type.intValue & bThreadFilterPublic) {
            return BChatSDK.config.defaultGroupChatAvatar;
        }
        else {
            return BChatSDK.config.defaultBlankAvatar;
        }
    }
    else if (users.count == 1) {
        // Only one user left so use their picture
        id<PUser> user = users.firstObject;
        return [UIImage imageWithData:user.image];
    }
    else {
        
        // When we get the user thumbnail image we make sure it is the size we want so resize it to be 100 x 100
        UIImage * image1 = [[UIImage imageWithData:((id<PUser>)users.firstObject).image] resizeImageToSize:CGSizeMake(100, 100)];
        
        // Then crop the image
        image1 = [image1 croppedImage:CGRectMake(25, 0, 49, 100)];
        
        // If there are two users then we need to split the picture in half
        if (users.count == 2) {
            
            // When we get the user thumbnail image we make sure it is the size we want so resize it to be 100 x 100
            UIImage * image2 = [[UIImage imageWithData:((id<PUser>)users.lastObject).image] resizeImageToSize:CGSizeMake(100, 100)];
            
            // Then crop the image
            image2 = [image2 croppedImage:CGRectMake(25, 0, 49, 100)];
            
            // Combine the images
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0.0);
            
            [image1 drawInRect:CGRectMake(0, 0, 49, 100)];
            [image2 drawInRect:CGRectMake(51, 0, 49, 100)];
        }
        else {
            
            // Thumbnails done by using parse change
            UIImage * image2 = [UIImage imageWithData:((id<PUser>)users[1]).image];
            UIImage * image3 = [UIImage imageWithData:((id<PUser>)users[2]).image];
            
            // Combine the images
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0.0);
            
            [image1 drawInRect:CGRectMake(0, 0, 49, 100)];
            [image2 drawInRect:CGRectMake(51, 0, 49, 49)];
            [image3 drawInRect:CGRectMake(51, 51, 49, 49)];
        }
        
        UIImage * finalImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return finalImage;
    }}

-(NSDate *) orderDate {
    id<PMessage> message = self.newestMessage;
    if (message) {
        return message.date;
    }
    else {
        return self.creationDate;
    }
}

-(BOOL) isEqualToEntity: (id<PEntity>) entity {
    return [self.entityID isEqualToString:entity.entityID];
}

@end
