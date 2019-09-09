//
//  PCall.h
//  ChatSDK
//
//  Created by Pepe Becker on 9/3/19.
//

#ifndef PCall_h
#define PCall_h

@protocol PCall <NSObject>

- (void)answer;
- (void)hangup;
- (void)pauseVideo;
- (void)resumeVideo;

- (void)setDelegate:(id<PCallDelegate>)delegate;
- (id<PCallDelegate>)delegate;

- (NSString *)callId;
- (NSString *)remoteUserId;
- (BOOL)isOutgoing;

@end

#endif /* PCall_h */
