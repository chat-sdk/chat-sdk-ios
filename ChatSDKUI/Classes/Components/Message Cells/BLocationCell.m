//
//  BLocation.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 27/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BLocationCell.h"

#import <ChatSDK/UI.h>
#import <ChatSDK/Core.h>

@implementation BLocationCell

@synthesize map;
@synthesize mapImageView;

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        map = [BMapViewManager sharedManager].mapFromPool;
//        [self.bubbleImageView addSubview:map.mapView];
        
        mapImageView = [[UIImageView alloc] init];
        mapImageView.layer.cornerRadius = 10;
        mapImageView.clipsToBounds = YES;
        mapImageView.userInteractionEnabled = NO;
        
        [self.bubbleImageView addSubview:mapImageView];
        
    }
    return self;
}

-(void) setMessage: (id<PElmMessage>) message withColorWeight:(float)colorWeight {
    [super setMessage:message withColorWeight:colorWeight];
    
    self.bubbleImageView.image = Nil;
    
    float longitude = [self.message.meta[bMessageLongitude] floatValue];
    float latitude = [self.message.meta[bMessageLatitude] floatValue];
    
    [mapImageView sd_setImageWithURL:[BGoogleUtils getMapImageURL:latitude longitude:longitude width:bMaxMessageWidth height:bMaxMessageWidth]
                    placeholderImage:Nil
                             options:SDWebImageLowPriority & SDWebImageScaleDownLargeImages];
    
}

-(void) willDisplayCell {
    [super willDisplayCell];
}

-(UIView *) cellContentView {
    return mapImageView;
}

#pragma Cell sizing static methods

+(NSNumber *) messageContentHeight: (id<PElmMessage>) message maxWidth: (float) maxWidth {
    return [self messageContentWidth:message maxWidth:maxWidth];
}

+(NSValue *) messageBubblePadding: (id<PElmMessage>) message {
    return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0)];
}

@end
