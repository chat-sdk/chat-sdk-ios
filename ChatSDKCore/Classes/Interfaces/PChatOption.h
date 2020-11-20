//
//  PChatOption.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 17/12/2016.
//
//

#ifndef PChatOption_h
#define PChatOption_h

@class RXPromise;
@protocol PChatOptionsHandler;

@protocol PChatOption <NSObject>

-(UIImage *) icon;
-(NSString *) title;

- (RXPromise * ) execute: (UIViewController *) viewController threadEntityID: (NSString *) threadEntityID handler: (id<PChatOptionsHandler>) handler;

@end

#endif /* PChatOption_h */
