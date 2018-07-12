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
    
    float longitude = [[self.message textAsDictionary][bMessageLongitude] floatValue];
    float latitude = [[self.message textAsDictionary][bMessageLatitude] floatValue];
    
    // Load the map from Google Maps
    NSString * api = @"https://maps.googleapis.com/maps/api/staticmap";
    NSString * markers = [NSString stringWithFormat:@"markers=%f,%f", latitude, longitude];
    NSString * size = [NSString stringWithFormat:@"zoom=18&size=%ix%i", bMaxMessageWidth, bMaxMessageWidth];
    NSString * key = [NSString stringWithFormat:@"key=%@", [BChatSDK config].googleMapsApiKey];
    NSString * url = [NSString stringWithFormat:@"%@?%@&%@&%@", api, markers, size, key];
    
    [mapImageView sd_setImageWithURL:url placeholderImage:Nil options:SDWebImageLowPriority & SDWebImageScaleDownLargeImages];
    
    // Get a new map
//    [map setLongitude:longitude withLatitude:latitude];
    
}

-(void) willDisplayCell {
    [super willDisplayCell];
}

-(UIView *) cellContentView {
    return mapImageView;
}

-(void) dealloc {
//    [[BMapViewManager sharedManager] returnToPool: map];
}

@end
