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

-(void) loginWasSuccessful;
-(void) loginFailedWithError: (NSError *) error;

@end


#endif /* PGoogleLoginDelegate_h */
