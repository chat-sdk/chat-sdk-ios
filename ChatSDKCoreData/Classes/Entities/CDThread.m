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

-(NSMutableArray *) messagesWorkingList {
    if(!_messagesWorkingList) {
        _messagesWorkingList = [NSMutableArray new];
        [self resetMessages];
    }
    return _messagesWorkingList;
}

-(void) clearMessageCache {
    [_messagesWorkingList removeAllObjects];
}

-(void) resetMessages {
    [_messagesWorkingList removeAllObjects];
    [_messagesWorkingList addObjectsFromArray:[self loadMessagesWithCount:[BChatSDK config].chatMessagesToLoad ascending:NO]];
    [self reverse:_messagesWorkingList];
    
    //
    
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

// This will re
-(NSArray *) loadMessagesWithCount: (NSInteger) count ascending: (BOOL) ascending {
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    request.includesPendingChanges = YES;
    [request setFetchLimit:count];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:ascending]];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"thread = %@", self];
    
    NSArray * messages = [[BStorageManager sharedManager].a executeFetchRequest:request
                                                                     entityName:bMessageEntity
                                                                      predicate:predicate];
    
    return messages;
}

-(NSArray *) loadMoreMessages: (NSInteger) numberOfMessages {
    
    NSInteger count = _messagesWorkingList.count + numberOfMessages;
    count = MAX(count, [BChatSDK config].chatMessagesToLoad);
    
    // Get the next batch of messages
    [_messagesWorkingList removeAllObjects];
    
    // We want to get the count newest messages so we sent ascending to NO
    // Then we have to reverse the order of the list...
    [_messagesWorkingList addObjectsFromArray:[self loadMessagesWithCount:count ascending:NO]];
    
    // Now we need to reverse the order of the list
    [self reverse:_messagesWorkingList];
    
    return _messagesWorkingList;
}

-(void) optimize {
    NSArray * messages = [self loadMessagesWithCount:[BChatSDK config].chatMessagesToLoad ascending:YES];
    for(int i = 0; i < messages.count; i++) {
        CDMessage * message = (CDMessage *) messages[i];
        [message clearOptimizationProperties];
        [message updateOptimizationProperties];
    }
}

-(NSArray *) allMessages {
    return self.messages.allObjects;
}

-(BOOL) hasMessages {
    return self.lazyLastMessage != Nil;
}

-(void) addMessage: (id<PMessage>) message {
    CDMessage * cdMessage = (CDMessage *) message;
    cdMessage.thread = self;
    self.lastMessage = cdMessage;

    [[message lazyLastMessage] updatePosition];
    
    if(![self.messagesWorkingList containsObject:message]) {
        [self.messagesWorkingList addObject:message];
    }
}

-(void) removeMessage: (id<PMessage>) message {
    CDMessage * cdMessage = (CDMessage *) message;
    cdMessage.thread = Nil;
    
    [[BStorageManager sharedManager].a deleteEntity:cdMessage];
    if([self.messagesWorkingList containsObject:message]) {
        [self.messagesWorkingList removeObject:message];
    }
    
    // This is a bit nasty. Essentially, sometimes the working list will be empty
    // if we left the thread so we have to repopulate it
    [self resetMessages];
    self.lastMessage = self.messagesOrderedByDateDesc.firstObject;
    [[message lazyLastMessage] updatePosition];
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

-(CDMessage *) lazyLastMessage {
    if (self.lastMessage) {
        return self.lastMessage;
    }
    else {
        return self.messagesOrderedByDateDesc.firstObject;
    }
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
        
        // TODO: Should we have this here? Maybe this gets called too soon
        // but it's a good backup in case the app closes before we save
        message.delivered = @YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:bNotificationThreadRead object:Nil];
}

-(int) unreadMessageCount {
    int i = 0;
    for (id<PMessage> message in _messagesWorkingList) {
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
    for (id<PUser> user in tempUsers) {
        
        // Check if the user picture has been uploaded
        if (!user.thumbnail) {
            [users removeObject:user];
        }
    }
    
    // If users array empty then just return the defaut picture
    if (!users.count) {
        
        // Check how many users are in the conversation
        if (self.type.intValue & bThreadFilterPublic) {
            return [BChatSDK config].defaultGroupChatAvatar;
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
        UIImage * image1 = [[UIImage imageWithData:((id<PUser>)users.firstObject).thumbnail] resizeImageToSize:CGSizeMake(100, 100)];
        
        // Then crop the image
        image1 = [image1 croppedImage:CGRectMake(25, 0, 49, 100)];
        
        // If there are two users then we need to split the picture in half
        if (users.count == 2) {
            
            // When we get the user thumbnail image we make sure it is the size we want so resize it to be 100 x 100
            UIImage * image2 = [[UIImage imageWithData:((id<PUser>)users.lastObject).thumbnail] resizeImageToSize:CGSizeMake(100, 100)];
            
            // Then crop the image
            image2 = [image2 croppedImage:CGRectMake(25, 0, 49, 100)];
            
            // Combine the images
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(100, 100), NO, 0.0);
            
            [image1 drawInRect:CGRectMake(0, 0, 49, 100)];
            [image2 drawInRect:CGRectMake(51, 0, 49, 100)];
        }
        else {
            
            // Thumbnails done by using parse change
            UIImage * image2 = [UIImage imageWithData:((id<PUser>)users[1]).thumbnail];
            UIImage * image3 = [UIImage imageWithData:((id<PUser>)users[2]).thumbnail];
            
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
    id<PMessage> message = self.lazyLastMessage;
    if (message) {
        return message.date;
    }
    else {
        return self.creationDate;
    }
}

@end
