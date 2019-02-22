//
//  BMediaChatOption.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#import "BMediaChatOption.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

#import <MobileCoreServices/MobileCoreServices.h>

@implementation BMediaChatOption

-(instancetype) initWithType: (bPictureType) type {
    if((self = [self init])) {
        _type = type;
    }
    return self;
}

-(UIImage *) icon {
    NSString * image;
    switch (_type) {
        case bPictureTypeAlbumImage:
            image = @"icn_60_gallery.png";
            break;
        case bPictureTypeAlbumVideo:
            image = @"icn_60_video_clip.png";
            break;
        case bPictureTypeCameraImage:
            image = @"icn_60_camera.png";
            break;
        case bPictureTypeCameraVideo:
            image = @"icn_60_camera.png";
            break;
    }

    return [NSBundle uiImageNamed:image];
}

-(NSString *) title {
    NSString * title;
    switch (_type) {
        case bPictureTypeAlbumImage:
            title = [NSBundle t:bChoosePhoto];
            break;
        case bPictureTypeAlbumVideo:
            title = [NSBundle t:bChooseVideo];
            break;
        case bPictureTypeCameraImage:
            title = [NSBundle t:bCamera];
            break;
        case bPictureTypeCameraVideo:
            title = [NSBundle t:bCamera];
            break;
    }
    
    return title;
}

- (RXPromise * ) execute: (UIViewController *) viewController threadEntityID: (NSString *) threadEntityID {
    BSelectMediaAction * action =  [[BSelectMediaAction alloc] initWithType:_type viewController:viewController];
    return [action execute].thenOnMain(^id(id success) {
        if(action.videoData && action.coverImage && BChatSDK.videoMessage) {
            return [BChatSDK.videoMessage sendMessageWithVideo:action.videoData coverImage:action.coverImage withThreadEntityID:threadEntityID];
        }
        else if(action.photo && BChatSDK.imageMessage) {
            return [BChatSDK.imageMessage sendMessageWithImage:action.photo withThreadEntityID:threadEntityID];
        }
        return Nil;
    }, Nil);
}





@end
