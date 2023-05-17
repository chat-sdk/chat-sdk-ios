//
//  BFileMessageCell.m
//  ChatSDKModules
//
//  Created by Pepe Becker on 19.04.18.
//

#import "BFileMessageCell.h"
#import <ChatSDK/Core.h>
#import "FileMessage.h"
#import <ChatSDK/UI.h>
#import <MessageModules/MessageModules-Swift.h>

@implementation BFileMessageCell

@synthesize cellView;
@synthesize imageView;
@synthesize textLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        cellView = [[UIView alloc] init];

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cellView addSubview:imageView];

        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 130, 60)];
        [textLabel setFont:[UIFont systemFontOfSize:14]];
        [textLabel setNumberOfLines:0];
        [cellView addSubview:textLabel];

        [self.bubbleImageView addSubview:cellView];
    }
    return self;
}

-(void) setMessage: (id<PElmMessage>) message isSelected: (BOOL) selected {
    [super setMessage:message isSelected:selected];
    [textLabel setText:message.text];


    UIImage * icon;
    

    if ([message.delivered boolValue]) {
        NSURL * imageURL = [message imageURL];
        if (imageURL) {
            [imageView sd_setImageWithURL:imageURL];
        }
        else if ([BFileCache isFileCached:message.entityID]) {
            NSString * ext = [[message.text pathExtension] lowercaseString];
            NSString * imageName = [NSString stringWithFormat:@"file-type-%@.png", ext];

            icon = [FileMessageModule imageWithNamed:imageName];
            
            if (!icon) {
                icon = [FileMessageModule imageWithNamed:@"file.png"];
            }
        } else {
            icon = [FileMessageModule imageWithNamed:@"file-download.png"];
        }
    } else {
        icon = [FileMessageModule imageWithNamed:@"file.png"];
        UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGPoint center = CGPointMake(imageView.frame.size.width / 2, imageView.frame.size.height / 2);
        activityIndicator.frame = CGRectMake(center.x - 20, center.y - 20, 40, 40);
        [activityIndicator startAnimating];
        [imageView addSubview:activityIndicator];
        [imageView bringSubviewToFront:activityIndicator];
    }
    if (icon) {
        [imageView setImage:icon];
    }
}

-(UIView *) cellContentView {
    return cellView;
}

#pragma Cell sizing static methods

+(NSNumber *) messageContentHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    return @(60);
}

+(NSNumber *) messageContentWidth: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    return @(bMaxMessageWidth - 10.0);
}

+(NSValue *) messageBubblePadding: (id<PElmMessage>) message {
    return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10.0, 6.0, 10.0, 6.0)];
}

@end
