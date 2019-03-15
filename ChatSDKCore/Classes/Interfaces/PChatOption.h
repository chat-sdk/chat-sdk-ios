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
-(RXPromise *) execute;

@end

#endif /* PChatOption_h */
