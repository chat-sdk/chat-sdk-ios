//
//  PCallDelegate.h
//  ChatSDK
//
//  Created by Pepe Becker on 9/5/19.
//

#ifndef PCallDelegate_h
#define PCallDelegate_h

@protocol PCall;

@protocol PCallDelegate <NSObject>
@optional
- (void)callDidEnd:(id<PCall>)call;
- (void)callDidProgress:(id<PCall>)call;
- (void)callDidEstablish:(id<PCall>)call;
- (void)callDidPauseVideo:(id<PCall>)call;
- (void)callDidResumeVideo:(id<PCall>)call;
@end

#endif /* PCallDelegate_h */
