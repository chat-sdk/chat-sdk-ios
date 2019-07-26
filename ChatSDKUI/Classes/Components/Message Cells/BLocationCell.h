//
//  BLocation.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 27/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BMessageCell.h"
#import <CoreLocation/CoreLocation.h>

@class BMapViewWrapper;

@interface BLocationCell : BMessageCell<BMessageDelegate>

@property (nonatomic, readwrite) BMapViewWrapper * map;
@property (nonatomic, readwrite) UIImageView * mapImageView;

@end
