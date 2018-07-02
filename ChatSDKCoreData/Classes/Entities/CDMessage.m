//
//  CDMessage.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import "CDMessage.h"

#import <ChatSDK/CoreData.h>
#import <ChatSDK/Core.h>

@implementation CDMessage

-(float) getTextHeightWithFont: (UIFont *) font withWidth: (float) width {
    return [self.textString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName: font}
                                   context:Nil].size.height;
}

-(NSComparisonResult) compare: (id<PMessage>) message {
    return [self.date compare:message.date];
}

-(void) setUserModel:(id<PUser>)user {
    if ([user isKindOfClass:[CDUser class]]) {
        self.user = (CDUser *) user;
    }
}

-(id<PUser>) userModel {
    return self.user;
}

#pragma Image information

- (NSURL *)thumbnailURL {
    NSString * url = self.compatibilityMeta[bMessageThumbnailURL];

    // TODO: Depricated - remove this
    if (!url) {
        // Split up the message text then return the url of the thumbnail
        NSArray * myArray = [self.textString componentsSeparatedByString:@","];
        url = myArray[0];
    }
    
    return [NSURL URLWithString:url];
}

- (NSURL *)imageURL {
    NSString * url = self.compatibilityMeta[bMessageImageURL];
    
    // TODO: Depricated - remove this
    if (!url) {
        // Split up the message text then return the url of the thumbnail
        NSArray * myArray = [self.textString componentsSeparatedByString:@","];
        url = myArray[1];
    }
    return [NSURL URLWithString:url];
}

- (NSInteger)imageWidth {
    CGSize size = [self getImageSize];
    return size.width;
    
    // Check which one is bigger and then scale it to be 600 pixels
//    return size.width > size.height ? 600 : 600 * size.width/size.height;
}

- (NSInteger)imageHeight {
    
    CGSize size = [self getImageSize];
    return size.height;
    
    // Check which one is bigger and then scale it to be 600 pixels
//    return size.height > size.width ? 600 : 600 * size.height/size.width;
}

-(CGSize) getImageSize {
    NSNumber * widthNumber = self.compatibilityMeta[bMessageImageWidth];
    NSNumber * heightNumber = self.compatibilityMeta[bMessageImageHeight];
    
    float height = -1;
    float width = -1;
    
    // TODO: Depricated - remove this
    if (!widthNumber || !heightNumber) {
        
        NSArray * myArray = [self.textString componentsSeparatedByString:@","];
        
        if (myArray.count > 2) {
            
            NSArray * dimensions = [myArray[2] componentsSeparatedByString:@"&"];
            
            if (dimensions.count > 0) {
                width = [[dimensions[0] substringFromIndex:1] floatValue];
            }
            
            if (dimensions.count > 1) {
                // Take off the first letter and then use the dimensions
                height = [[dimensions[1] substringFromIndex:1] floatValue];
            }
        }
        
        if (height == -1 || width == -1) {
            return [UIImage imageWithData:self.placeholder].size;
        }
    }
    else {
        width = [widthNumber floatValue];
        height = [heightNumber floatValue];
    }
    
    return CGSizeMake(width, height);
}

-(NSDictionary *) compatibilityMeta {
    if (self.meta) {
        return self.meta;
    }
    else {
        return self.textAsDictionary;
    }
}

// TODO: Depricated - remove this
-(NSError *) setTextAsDictionary: (NSDictionary *) dict {
    self.json = dict;
    
    // Needed to support API 2
    NSError * error;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&error];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    self.text = myString;
    return error;
    
}

// TODO: Depricated - remove this
-(NSDictionary *) textAsDictionary {
    if(!self.json) {
        NSData *data =[self.text dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * response;
        NSError * error;
        if(data!=nil){
            response = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        }
        self.json = response;
    }
    return self.json;
}

-(NSString *) color {
    return self.user.messageColor;
}

-(id<PMessage>) model {
    return self;
}

-(bMessagePos) messagePosition {
    if (_position == Nil) {
        [self updateOptimizationProperties];
    }
    return [_position intValue];
}

-(NSString *) textString {
    return self.textAsDictionary[bMessageTextKey];
}

-(void) setTextString: (NSString *) text {
    [self setTextAsDictionary:@{bMessageTextKey: text ? text : @""}];
}

// This helps us know if we want to show it in the thread
- (BOOL)showUserNameLabelForPosition: (bMessagePos) position {
    if (self.senderIsMe) {
        return NO;
    }
    
    if (!(position & bMessagePosLast)) {
        return NO;
    }
    if (self.thread.type.integerValue & bThreadFilterPublic || self.thread.users.count > 2) {
        return YES;
    }

    return NO;
}

-(void) setReadStatus:(NSDictionary *)status {
    self.status = status;
}

-(bMessageReadStatus) readStatusForUserID: (NSString *) uid {
    if (!self.status) {
        return bMessageReadStatusNone;
    }

    NSDictionary * status = self.status;
    if(status && uid) {
        NSDictionary * userStatus = status[uid];
        return [userStatus[b_Status] intValue];
    }
    return bMessageReadStatusNone;
}

-(void) setReadStatus: (bMessageReadStatus) status_ forUserID: (NSString *) uid {
    NSMutableDictionary * mutableStatus = [NSMutableDictionary dictionaryWithDictionary:self.status];
    mutableStatus[uid] = @{b_Status: @(status_)};
    [self setReadStatus:mutableStatus];
}

-(bMessageReadStatus) readStatus {
    if (!self.status) {
        return bMessageReadStatusNone;
    }
    
    NSDictionary * status = self.status;
    BOOL allDelivered = YES;
    BOOL allRead = YES;
    for (NSDictionary * userStatus in status.allValues) {
        //NSString * date = userStatus[b_Date];
        NSNumber * sts = userStatus[b_Status];
        
        bMessageReadStatus s = sts.intValue;
        allDelivered = bMessageReadStatusDelivered <= s && allDelivered;
        allRead = bMessageReadStatusRead <= s && allRead;
    }
    if(allRead) {
        return bMessageReadStatusRead;
    }
    else if (allDelivered) {
        return bMessageReadStatusDelivered;
    }
    else {
        return bMessageReadStatusNone;
    }
}

-(CDMessage *) copy {
    CDMessage * message = [[BStorageManager sharedManager].a createEntity:bMessageEntity];
    message.entityID = [self.entityID copy];
    message.date = [self.date copy];
    message.placeholder = [self.placeholder copy];
    message.read = [self.read copy];
    message.resource = [self.resource copy];
    message.resourcePath = [self.resourcePath copy];
    message.text = [self.text copy];
    message.type = [self.type copy];
    message.thread = self.thread;
    message.user = self.user;
    message.status = [self.status copy];
    message.meta = [self.meta copy];
    return message;
}

-(void) setMetaValue: (id) value forKey: (NSString *) key {
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:self.meta];
    dict[key] = value;
    self.meta = dict;
}

-(id) metaValueForKey: (NSString *) key {
    return self.meta[key];
}

-(BOOL) senderIsMe {
    
    return self.userModel.isMe;
    
//    if(_senderIsMe == Nil) {
//        [self updateOptimizationProperties];
//    }
//
//    return [_senderIsMe boolValue];
}

// We store certain shortcuts for optimization purposes
// Message position
// Sender is me
// Next and last message
// Update these if necessary
-(void) updateOptimizationProperties {
    if(!self.lastMessage || !self.nextMessage) {
        NSArray * messages = self.thread.messagesOrderedByDateAsc;
        NSInteger index = [messages indexOfObject:self];
        
        if(index != NSNotFound) {
            if(!self.lastMessage && index > 0) {
                self.lastMessage = messages[index - 1];
            }
            if (!self.nextMessage && index < messages.count - 1) {
                self.nextMessage = messages[index + 1];
            }
        }
    }
    
//    if(_senderIsMe == Nil) {
//        _senderIsMe = @(self.userModel.isMe);
//    }
    
    [self updatePosition];
}

-(void) clearOptimizationProperties {
    _senderIsMe = Nil;
    _position = Nil;
}

-(void) updatePosition {
    BOOL isFirst = !self.lastMessage || self.lastMessage.senderIsMe != self.senderIsMe;
    BOOL isLast = !self.nextMessage || self.nextMessage.senderIsMe != self.senderIsMe;
    
    int position = 0;
    if (isFirst) {
        position = position | bMessagePosFirst;
    }
    if (isLast) {
        position = position | bMessagePosLast;
    }
   
    _position = @(position);
}

-(CDMessage *) lazyLastMessage {
    if(!self.lastMessage) {
        [self updateOptimizationProperties];
    }
    return self.lastMessage;
}

-(CDMessage *) lazyNextMessage {
    if(!self.nextMessage) {
        [self updateOptimizationProperties];
    }
    return self.nextMessage;
}


@end
