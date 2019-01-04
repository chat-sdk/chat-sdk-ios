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

@protocol PChatOption <NSObject>

-(UIImage *) icon;
-(NSString *) title;

@optional
- (RXPromise * ) execute: (NSString *) threadEntityID;
- (RXPromise * ) execute: (UIViewController *) viewController threadEntityID: (NSString *) threadEntityID;

@end

#endif /* PChatOption_h */
