//
//  CDThread.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import "CDThread.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatCoreData.h>

@implementation CDThread

-(instancetype) init {
    if((self = [super init])) {
        [self optimizeMessageProperties];
    }
    return self;
}

-(NSMutableArray *) messagesWorkingList {
    
    
    if(!_messagesWorkingList) {
        _messagesWorkingList = [NSMutableArray new];
        [self resetMessages];
    }
    return _messagesWorkingList;
}

-(void) resetMessages {
    [_messagesWorkingList removeAllObjects];
    [_messagesWorkingList addObjectsFromArray:[self loadMessagesWithCount:[BChatSDK config].chatMessagesToLoad ascending:NO]];
    
//    NSArray * messages = [self orderMessagesByDateDesc:self.allMessages];
//
//    for(int i = 0; i < bMessageWorkingListInitialSize; i++) {
//        if(i < messages.count) {
//            [_messagesWorkingList addObject:messages[i]];
//        }
//        else {
//            break;
//        }
//    }
}

-(NSArray *) loadMessagesWithCount: (int) count ascending: (BOOL) ascending {
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setFetchLimit:count];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:ascending]];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"thread = %@", self];
    
    NSArray * messages = [[BStorageManager sharedManager].a executeFetchRequest:request
                                                                     entityName:bMessageEntity
                                                                      predicate:predicate];
    
    return messages;
}

// Adds extra messages to the
-(NSArray *) loadMoreMessages: (NSInteger) numberOfMessages {
    
    NSInteger count = _messagesWorkingList.count + numberOfMessages;
    // Get the next batch of messages
    [_messagesWorkingList removeAllObjects];
    [_messagesWorkingList addObjectsFromArray:[self loadMessagesWithCount:count ascending:YES]];
    
//    NSArray * allMessages = [self orderMessagesByDateAsc:self.allMessages];
//
//    // The endIndex of the last message to add
//    NSInteger endIndex = allMessages.count - self.messagesWorkingList.count - 1;
//
//    NSMutableArray * messages = [NSMutableArray new];
//
//    // Loop backwards from the end index adding the messages to the working list
//    for(NSInteger i = endIndex; i > endIndex - numberOfMessages; i--) {
//        if(i >= 0) {
//            [messages addObject:allMessages[i]];
//        }
//    }
//
//    [_messagesWorkingList addObjectsFromArray:messages];
    
    return _messagesWorkingList;
}

-(void) optimizeMessageProperties {
    NSArray * messages = self.messagesOrderedByDateAsc;
    for(int i = 0; i < messages.count; i++) {
        CDMessage * message = (CDMessage *) messages[i];
        if(!message.lastMessage && i > 0) {
            message.lastMessage = messages[i - 1];
        }
        if(![message metaValueForKey:bMessageSenderIsMe]) {
            [message setMetaValue:@(message.userModel.isMe) forKey:bMessageSenderIsMe];
        }
        [message updatePosition];
    }
}

-(NSArray *) allMessages {
    return self.messages.allObjects;
}

-(BOOL) hasMessages {
    return self.messagesWorkingList.count > 0;
}

-(void) addMessage: (id<PMessage>) message {
    ((CDMessage *) message).thread = self;
    
    [[message lazyLastMessage] updatePosition];
    
    
    if(![self.messagesWorkingList containsObject:message]) {
        [self.messagesWorkingList addObject:message];
    }
}

-(void) removeMessage: (id<PMessage>) message {
    ((CDMessage *)message).thread = Nil;
    [[BStorageManager sharedManager].a deleteEntity:message];
    
    if([self.messagesWorkingList containsObject:message]) {
        [self.messagesWorkingList removeObject:message];
    }
}

-(void) setDeleted:(NSNumber *)deleted_ {
    self.deleted_ = deleted_;
}

-(NSArray *) orderMessagesByDateAsc: (NSArray *) messages {
    return [messages sortedArrayUsingComparator:^(id<PMessage> m1, id<PMessage> m2) {
        return [m1.date compare:m2.date];
    }];
}

-(NSArray *) messagesOrderedByDateAsc {
    return [self orderMessagesByDateAsc:self.messagesWorkingList];
}

-(NSArray *) messagesOrderedByDateDesc {
    return [self.messagesWorkingList sortedArrayUsingComparator:^(id<PMessage> m1, id<PMessage> m2) {
        return [m2.date compare:m1.date];
    }];
}

-(NSArray *) orderMessagesByDateDesc: (NSArray *) messages {
    return [messages sortedArrayUsingComparator:^(id<PMessage> m1, id<PMessage> m2) {
        return [m2.date compare:m1.date];
    }];
}

-(NSDate *) lastMessageAdded {
    NSDate * date = self.creationDate;
    if (self.messages.count) {
        date = ((id<PMessage>)self.messagesOrderedByDateDesc.firstObject).date;
    }
    return date;
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
        if (![user isEqual:NM.currentUser]) {
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
    for(id<PMessage> message in self.messages) {
        message.read = @YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationThreadRead object:Nil];
}

-(int) unreadMessageCount {
    int i = 0;
    for (id<PMessage> message in self.messages) {
        if (!message.read.boolValue) {
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
        if (![self.users containsObject:user]) {
            [self addUsersObject:(CDUser *)user];
        }
    }
}

- (void)removeUser:(id<PUser>) user {
    if ([user isKindOfClass:[CDUser class]]) {
        if ([self.users containsObject:user]) {
            [self removeUsersObject:(CDUser *) user];
        }
    }
}

-(id<PUser>) otherUser {
    id<PUser> currentUser = NM.currentUser;
    if (self.type.intValue == bThreadType1to1 || self.users.count == 2) {
        for (id<PUser> user in self.users) {
            if (![user isEqual:currentUser]) {
                return user;
            }
        }
    }
    return Nil;
}

// TODO: Move this to UI module
- (UIImage *)imageForThread {
    
    NSMutableArray * users = [NSMutableArray arrayWithArray:self.users.allObjects];
    
    // Remove the current user from the array
    [users removeObject:NM.currentUser];
    
    // Create a temporary array as we cannot loop through an array and remove users
    NSMutableArray * tempUsers = [NSMutableArray arrayWithArray:users];
    
    // We want to remove any users who have the automatic profile picture
    for (<PUser> user in tempUsers) {
        
        // Check if the user picture has been uploaded
        if (!user.thumbnail) {
            [users removeObject:user];
        }
    }
    
    // If users array empty then just return the defaut picture
    if (!users.count) {
        
        // Check how many users are in the conversation
        if (self.type.intValue & bThreadFilterPublic) {
            return [NSBundle imageNamed:bDefaultPublicGroupImage framework:@"ChatSDK" bundle:@"ChatUI"];
        }
        else {
            return [BChatSDK config].defaultBlankAvatar;
        }
    }
    else if (users.count == 1) {
        // Only one user left so use their picture
        id<PUser> user = users.firstObject;
        return [UIImage imageWithData:user.thumbnail];
    }
    else {
        
        // When we get the user thumbnail image we make sure it is the size we want so resize it to be 100 x 100
        UIImage * image1 = [[UIImage imageWithData:((<PUser>)users.firstObject).thumbnail] resizeImageToSize:CGSizeMake(100, 100)];
        
        // Then crop the image
        image1 = [image1 croppedImage:CGRectMake(25, 0, 49, 100)];
        
        // If there are two users then we need to split the picture in half
        if (users.count == 2) {
            
            // When we get the user thumbnail image we make sure it is the size we want so resize it to be 100 x 100
            UIImage * image2 = [[UIImage imageWithData:((<PUser>)users.lastObject).thumbnail] resizeImageToSize:CGSizeMake(100, 100)];
            
            // Then crop the image
            image2 = [image2 croppedImage:CGRectMake(25, 0, 49, 100)];
            
            // Combine the images
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0.0);
            
            [image1 drawInRect:CGRectMake(0, 0, 49, 100)];
            [image2 drawInRect:CGRectMake(51, 0, 49, 100)];
        }
        else {
            
            // Thumbnails done by using parse change
            UIImage * image2 = [UIImage imageWithData:((<PUser>)users[1]).thumbnail];
            UIImage * image3 = [UIImage imageWithData:((<PUser>)users[2]).thumbnail];
            
            // Combine the images
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0.0);
            
            [image1 drawInRect:CGRectMake(0, 0, 49, 100)];
            [image2 drawInRect:CGRectMake(51, 0, 49, 49)];
            [image3 drawInRect:CGRectMake(51, 51, 49, 49)];
        }
        
        UIImage * finalImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return finalImage;
    }
}

-(NSDate *) orderDate {
    id<PMessage> message = [self messagesOrderedByDateDesc].firstObject;
    if (message) {
        return message.date;
    }
    return self.creationDate;
}


@end
