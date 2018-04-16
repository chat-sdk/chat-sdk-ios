//
//  BMessageLayout.m
//  ChatUI
//
//  Created by Benjamin Smiley-andrews on 02/04/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "BMessageLayout.h"

#import <ChatSDK/PElmMessage.h>

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

@implementation BMessageLayout

+(BMessageLayout *) layoutWithMessage: (id<PElmMessage>) message {
    return [[self alloc] initWithMessage:message];
}

-(instancetype) initWithMessage: (id<PElmMessage>) message {
    if((self = [self init])) {
        _message = message;
    }
    return self;
}

-(float) messageHeight {
    
    switch ((bMessageType)_message.type.intValue) {
        case bMessageTypeImage:
        case bMessageTypeVideo: {
            if (_message.imageHeight > 0 && _message.imageWidth > 0) {
                
                // We want the height to be less than the max height and more than the min height
                // First check if the calculated height is bigger than the max height, we take the smaller of these
                // Next we take the max of this value and the min value, this ensures the image is at least the min height
                return MAX(bMinMessageHeight, MIN([self messageWidth] * _message.imageHeight / _message.imageWidth, bMaxMessageHeight));
            }
            return 0;
        }
        case bMessageTypeLocation:
            return self.messageWidth;
        case bMessageTypeAudio:
            return 50;
        case bMessageTypeSticker:
            return 140;
        default:
            return [self getTextHeightWithFont:[UIFont systemFontOfSize:bDefaultFontSize] withWidth:[self messageWidth]];
    }
}

-(float) messageWidth {
    switch ((bMessageType)_message.type.intValue) {
        case bMessageTypeText:
        case bMessageTypeSystem:
            return MAX(MIN([self textWidth:_message.textString], bMaxMessageWidth), bTimeLabelWidth);
        case bMessageTypeImage:
        case bMessageTypeVideo:
        case bMessageTypeLocation:
            return bMaxMessageWidth;
        case bMessageTypeAudio:
            return 160;
        case bMessageTypeSticker:
            return 140;
        default:
            return bMaxMessageWidth;
    }
}

-(float) textWidth: (NSString *) text {
    if (text) {
        UIFont * font = [UIFont systemFontOfSize:bDefaultFontSize];
        if (font) {
            return [text boundingRectWithSize:CGSizeMake(bMaxMessageWidth, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName: font}
                                      context:Nil].size.width;
        }
    }
    return 0;
}

-(float) bubbleHeight {
//    return self.messageHeight + bTimeLabelHeight + /*[self cellMargin] + */self.bubblePadding * 2;
    switch ((bMessageType)_message.type.intValue) {
        case bMessageTypeText:
            return self.messageHeight + bTimeLabelHeight + self.bubblePadding * 2;
        default:
            return self.messageHeight + self.bubblePadding * 2;
    }
}

-(float) cellHeight {
    return self.bubbleHeight + self.bubbleMargin + self.nameHeight;
}

-(float) nameHeight {
    bMessagePos pos = [_message messagePosition];
    // Do we want to show the users name label
    if ([_message showUserNameLabelForPosition:pos]) {
        return bUserNameHeight;
    }
    return 0;
}

-(float) bubbleWidth {
    return self.messageWidth + self.bubblePadding * 2;
}

-(float) bubbleMargin {
    switch ((bMessageType)_message.type.intValue) {
        case bMessageTypeText:
        case bMessageTypeImage:
        case bMessageTypeLocation:
        case bMessageTypeAudio:
        case bMessageTypeVideo:
        case bMessageTypeSystem:
        case bMessageTypeSticker:
            return 2.0;
        case bMessageTypeCustom:
        case bMessageTypeFile:
        default:
            return 0;
    }
}

-(float) bubblePadding {
    switch ((bMessageType)_message.type.intValue) {
        case bMessageTypeText:
            return 12.0;
        case bMessageTypeImage:
        case bMessageTypeLocation:
        case bMessageTypeAudio:
        case bMessageTypeVideo:
            return 3.0;
        case bMessageTypeSystem:
            return 5.0;
        case bMessageTypeSticker:
            return 0.0;
        case bMessageTypeCustom:
        case bMessageTypeFile:
        default:
            return 0;
    }
}

-(float) profilePicturePadding {
    switch ((bMessageType)_message.type.intValue) {
        case bMessageTypeText:
        case bMessageTypeImage:
        case bMessageTypeLocation:
        case bMessageTypeAudio:
        case bMessageTypeVideo:
        case bMessageTypeSticker:
        case bMessageTypeSystem:
            return 4.0;
        case bMessageTypeCustom:
        case bMessageTypeFile:
        default:
            return 0;
    }
}

-(float) profilePictureDiameter {
    return 36;
}

-(float) getTextHeightWithWidth: (float) width {
    return [_message.textString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:bDefaultFontSize]}
                                   context:Nil].size.height;
}

-(float) getTextHeightWithFont: (UIFont *) font withWidth: (float) width {
    return [_message.textString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName: font}
                                   context:Nil].size.height;
}


@end
