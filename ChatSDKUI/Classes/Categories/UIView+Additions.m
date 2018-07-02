//
//  UIView+Additions1.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 16/04/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "UIView+Additions.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation UIView(Additions)

-(void) setCenterX: (float) x {
    CGPoint p = self.center;
    p.x = x;
    self.center = p;
}

-(float) getBoundsWidth {
    return self.bounds.size.width;
}

-(void) setCenterDX: (float) dx {
    [self setCenterX: self.center.x + dx];
}

-(void) setViewFrameX: (float) x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(void) setViewFrameY: (float) y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(void) setViewFrameX:(float) x withY: (float) y {
    [self setViewFrameX:x];
    [self setViewFrameY:y];
}

-(void) setViewFrameWidth: (float) width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

-(void) setViewFrameHeight: (float) height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(void) setViewFrameDeltaX: (float) dx {
    [self setViewFrameX:self.frame.origin.x + dx];
}

-(void) setViewFrameDeltaY: (float) dy {
    [self setViewFrameY:self.frame.origin.y + dy];
}

-(void) setViewFrameSize: (CGSize) size {
    [self setViewFrameWidth:size.width];
    [self setViewFrameHeight:size.height];
}

-(void) setViewFrameDeltaW: (float) dw {
    [self setViewFrameWidth:self.fw + dw];
}

-(void) setViewFrameDeltaH: (float) dh {
    [self setViewFrameHeight:self.fh + dh];
}

-(float) fx {
    return self.frame.origin.x;
}

-(float) fy {
    return self.frame.origin.y;
}

-(float) fw {
    return self.frame.size.width;
}

-(float) fh {
    return self.frame.size.height;
}

-(float) cx {
    return self.center.x;
}

-(float) cy {
    return self.center.y;
}

-(void) fadeToAlpha: (float) alpha withTime: (float) time {
    
    if (alpha > 0) {
        self.hidden = NO;
    }
    
    [UIView animateWithDuration:time animations:^{
        self.alpha = alpha;
    } completion:^(BOOL finished) {
        if (alpha == 0) {
            self.hidden = YES;
        }
    }];
}

-(void) startShaking {
    
    CABasicAnimation* animRot = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [animRot setToValue:[NSNumber numberWithDouble:-M_PI/128]];
    [animRot setFromValue:[NSNumber numberWithDouble:M_PI/128]]; // rotation angle
    [animRot setDuration:0.1];
    [animRot setRepeatCount:NSUIntegerMax];
    [animRot setAutoreverses:YES];
    
    CABasicAnimation* animY = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animY setToValue:[NSNumber numberWithFloat:-1]];
    [animY setFromValue:[NSNumber numberWithFloat:1]]; // rotation angle
    [animY setDuration:0.2];
    [animY setRepeatCount:NSUIntegerMax];
    [animY setAutoreverses:YES];
    
    [self.layer addAnimation:animRot forKey:@"iconShakeR"];
    [self.layer addAnimation:animY forKey:@"iconShakeY"];
}

-(void) stopShaking {
    [self.layer removeAllAnimations];
}

-(void) printFrame {
    NSLog(@"x: %f, y: %f, w: %f, h: %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

-(void) centerViewForScreenSize: (CGSize) screenSize {
    [self setViewFrameX:(screenSize.width - self.fw)/2.0
              withY:(screenSize.height - self.fh)/2.0];
}

-(void) setZ: (float) z {
    for (UIView * sView in self.subviews) {
        [sView setZ:z];
    }
}

-(void) makeRound {
    self.layer.cornerRadius = self.frame.size.width / 2.0;
}

+(void) alertWithTitle: (NSString *) title withError: (NSError *) error {
    [self alertWithTitle:title withMessage:error.localizedDescription];
}

+(void) alertWithTitle: (NSString *) title withMessage: (NSString *) message {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:Nil cancelButtonTitle:[NSBundle t:bOk] otherButtonTitles: nil] show];
}

+(CGSize) screenSizeForOrientation
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

@end
