//
//  BBaseLocationMessageHandler.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/11/2016.
//
//

#import "BBaseLocationMessageHandler.h"

#import <MapKit/MapKit.h>

#import <ChatSDK/Core.h>
#import <ChatSDK/ChatSDK-Swift.h>

@implementation BBaseLocationMessageHandler

-(RXPromise *) sendMessageWithLocation:(CLLocation *)location withThreadEntityID:(NSString *)threadID {
    
    [BChatSDK.db beginUndoGroup];
    
    id<PMessage> message = [BChatSDK.db createMessageEntity];
    
    message.type = @(bMessageTypeLocation);
    
    id<PThread> thread = [BChatSDK.db fetchEntityWithID:threadID withType:bThreadEntity];

    message.date = BChatSDK.core.now;
    message.userModel = BChatSDK.currentUser;
    [message setDelivered:@NO];
    [message setRead:@YES];
    message.flagged = @NO;

    [thread addMessage: message];
    
    // TODO: Get rid of this
    NSString * messageText = [NSString stringWithFormat:@"%f,%f",location.coordinate.latitude,location.coordinate.longitude];
    
    int dim = BChatSDK.config.maxImageDimension;
    NSString * url = [GoogleUtils getMapImageURLWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude width:dim height:dim];
    
    [message setMeta:@{bMessageText: messageText,
                       bMessageLongitude: @(location.coordinate.longitude),
                       bMessageLatitude: @(location.coordinate.latitude),
                       bMessageImageWidth: @(dim),
                       bMessageImageHeight: @(dim),
                       bMessageImageURL: url}];
    
    return [BChatSDK.thread sendMessage:message];

}

@end
