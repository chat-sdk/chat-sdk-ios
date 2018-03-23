//
//  CDMessage.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/08/2016.
//
//

#import "CDMessage.h"

#import <ChatSDK/ChatCoreData.h>
#import <ChatSDK/ChatCore.h>

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

+(MKCoordinateRegion) regionForLongitude: (double) longitude latitude: (double) latitude {
    return [self regionForLongitude:longitude latitude:latitude area:bLocationDefaultArea];
}

+(MKCoordinateRegion) regionForLongitude: (double) longitude latitude: (double) latitude area: (float) area {
    
    CLLocationCoordinate2D location;
    location.longitude = longitude;
    location.latitude = latitude;
    
    return MKCoordinateRegionMakeWithDistance(location, area, area);
}

+(MKPointAnnotation *) annotationForLongitude: (double) longitude latitude: (double) latitude {
    
    CLLocationCoordinate2D location;
    location.longitude = longitude;
    location.latitude = latitude;
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:location];
    return annotation;
}

+(CLLocationCoordinate2D) locationForString: (NSString *) text {
    
    NSArray * coordinates = [text componentsSeparatedByString:@","];
    
    double longitude = 0;
    double latitude = 0;
    
    if (coordinates.count >= 2) {
        
        // Location
        latitude = ((NSString *)coordinates[0]).doubleValue;
        longitude = ((NSString *)coordinates[1]).doubleValue;
        
    }
    else {
        NSLog(@"Error parsing location string: %@", text);
    }
    
    CLLocationCoordinate2D location;
    location.longitude = longitude;
    location.latitude = latitude;
    
    return location;
}

#pragma Image information

- (NSURL *)thumbnailURL {
    // Split up the message text then return the url of the thumbnail
    NSArray * myArray = [self.textString componentsSeparatedByString:@","];
    
    return [NSURL URLWithString:myArray[0]];
}

- (NSURL *)mainImageURL {
    // Split up the message text then return the url of the thumbnail
    NSArray * myArray = [self.textString componentsSeparatedByString:@","];
    
    return [NSURL URLWithString:myArray[1]];
}

- (NSInteger)imageWidth {
    CGSize size = [self getImageSize];
    
    // Check which one is bigger and then scale it to be 600 pixels
    return size.width > size.height ? 600 : 600 * size.width/size.height;
}

- (NSInteger)imageHeight {
    
    CGSize size = [self getImageSize];
    
    // Check which one is bigger and then scale it to be 600 pixels
    return size.height > size.width ? 600 : 600 * size.height/size.width;
}

-(CGSize) getImageSize {
    
    float height = -1;
    float width = -1;
    
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
    
    return CGSizeMake(width, height);
}

-(NSError *) setTextAsDictionary: (NSDictionary *) dict {
    self.json = dict;
    
    // Needed to support API 2
    NSError * error;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:dict options:0 error:&error];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    self.text = myString;
    return error;
    
}

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
    [self updateOptimizationProperties];
    return [[self metaValueForKey:bMessagePosition] intValue];
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
    if([self metaValueForKey:bMessageSenderIsMe] == Nil) {
        [self updateOptimizationProperties];
    }
    return [[self metaValueForKey:bMessageSenderIsMe] boolValue];
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
        }
    }
    
    if([self metaValueForKey:bMessageSenderIsMe] == Nil) {
        BOOL isMe = self.userModel.isMe;
        [self setMetaValue:@(isMe) forKey:bMessageSenderIsMe];
    }
    
    [self updatePosition];
}

-(void) clearOptimizationProperties {
    [self setMetaValue:Nil forKey:bMessageSenderIsMe];
}

-(void) updatePosition {
    //BOOL isMine = [[message userModel] isEqual:NM.currentUser];
    BOOL isFirst = !self.lastMessage || self.lastMessage.user.entityID != NM.currentUser.entityID;
    BOOL isLast = !self.nextMessage || self.nextMessage.user.entityID  != NM.currentUser.entityID;
    
    int position = 0;
    if (isFirst) {
        position = position | bMessagePosFirst;
    }
    if (isLast) {
        position = position | bMessagePosLast;
    }
    
    [self setMetaValue:@(position) forKey:bMessagePosition];
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
