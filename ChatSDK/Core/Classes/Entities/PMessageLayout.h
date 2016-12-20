//
//  PMessageLayout.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 09/04/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

@protocol PMessageLayout <NSObject>

-(float) bubbleWidth;
-(float) bubbleHeight;
-(float) bubbleMargin;
-(float) bubblePadding;
-(float) messageWidth;
-(float) messageHeight;
-(float) profilePictureDiameter;
-(float) profilePicturePadding;
-(float) cellHeight;
-(float) nameHeight;

@end