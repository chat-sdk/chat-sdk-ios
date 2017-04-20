//
//  PGoogleLoginDelegate.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 29/03/2017.
//
//

#ifndef PGoogleLoginDelegate_h
#define PGoogleLoginDelegate_h

@class RXPromise;

@protocol PGoogleLoginDelegate <NSObject>

-(RXPromise *) loginWasSuccessful;
-(RXPromise *) loginFailedWithError: (NSError *) error;

@end


#endif /* PGoogleLoginDelegate_h */
