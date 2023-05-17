//
//  BStickerMessageCell.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 21/10/2016.
//
//

#import "BStickerMessageCell.h"
#import "PMessage.h"
#import "UIImage+Additions.h"
#import <ChatSDK/Core.h>
#import "StickerMessage.h"
//#import "Headers.h"
#import <FLAnimatedImage/FLAnimatedImage.h>

#import <MessageModules/MessageModules-Swift.h>
//#import "Headers.h"

@implementation BStickerMessageCell

@synthesize stickerView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        stickerView = [[FLAnimatedImageView alloc] init];
        stickerView.clipsToBounds = YES;
        stickerView.userInteractionEnabled = NO;
        
        // Turn off the bubble image around the sticker
        [self.bubbleImageView addSubview:stickerView];
    }
    return self;
}

-(void) setMessage: (id<PElmMessage>) message isSelected: (BOOL) selected {
    [super setMessage:message isSelected:selected];
    
    if (selected) {
        [self showCheck];
    } else {
        [self hideCheck];
    }
    
    self.bubbleImageView.image = Nil;
    
    stickerView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImage * missingImage = [StickerMessageModule.shared image:@"icn_140_stickerMissing.png"];
    // If the sticker image doesn't exist then add a message picture saying to download the update
    if ([message.text containsString:@".gif"]) {
        FLAnimatedImage * image = [StickerMessageModule.shared animatedImage:message.text];
        stickerView.animatedImage = image;
        if (image == nil) {
            stickerView.image = missingImage;
        } else {
            stickerView.image = nil;
        }
    } else {
        UIImage * stickerImage = [StickerMessageModule.shared image:message.text];
        stickerView.image = stickerImage ? stickerImage : missingImage;
        stickerView.animatedImage = nil;
    }
    stickerView.layer.cornerRadius = 10;
    stickerView.clipsToBounds = true;
}

-(UIView *) cellContentView {
    return stickerView;
}

#pragma Cell sizing static methods

+(NSNumber *) messageContentHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    return @(140);
}

+(NSNumber *) messageContentWidth: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    return @(140);
}

@end
