//
//  UIView+Additions1.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 16/04/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface UIView(Additions)

-(void) setCenterX: (float) x;
-(void) setCenterDX: (float) dx;

-(float) getBoundsWidth;

-(void) setViewFrameX: (float) x;
-(void) setViewFrameY: (float) y;
-(void) setViewFrameX:(float) x withY: (float) y;

-(void) setViewFrameWidth: (float) width;
-(void) setViewFrameHeight: (float) height;
-(void) setViewFrameSize: (CGSize) size;

-(void) setViewFrameDeltaX: (float) dx;
-(void) setViewFrameDeltaY: (float) dy;

-(void) setViewFrameDeltaW: (float) dw;
-(void) setViewFrameDeltaH: (float) dh;

-(float) fx;
-(float) fy;
-(float) fw;
-(float) fh;

-(float) cy;
-(float) cx;

-(void) startShaking;
-(void) stopShaking ;

-(void) fadeToAlpha: (float) alpha withTime: (float) time;

-(void) printFrame;
-(void) centerViewForScreenSize: (CGSize) screenSize;
-(void) setZ: (float) z;

-(void) makeRound;

+(void) alertWithTitle: (NSString *) title withError: (NSError *) error;
+(void) alertWithTitle: (NSString *) title withMessage: (NSString *) message;

+(CGSize) screenSizeForOrientation;

@end
