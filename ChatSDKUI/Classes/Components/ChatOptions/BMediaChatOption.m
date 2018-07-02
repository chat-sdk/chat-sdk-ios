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

- (RXPromise * ) execute {
    BSelectMediaAction * action =  [[BSelectMediaAction alloc] initWithType:_type viewController:self.parent.delegate.currentViewController];
    return [action execute].thenOnMain(^id(id success) {
        if(action.videoData && action.coverImage && NM.videoMessage) {
            return [self.parent.delegate sendVideoMessage:action.videoData withCoverImage:action.coverImage];
        }
        else if(action.photo && NM.imageMessage) {
            return [self.parent.delegate sendImageMessage:action.photo];
        }
        return Nil;
    }, Nil);
}





@end
