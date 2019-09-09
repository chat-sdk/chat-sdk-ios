//
//  PCallHandler.h
//  ChatSDKModules
//
//  Created by Pepe Becker on 9/3/19.
//

#ifndef PCallHandler_h
#define PCallHandler_h

@class RXPromise;
@protocol PCall;

@protocol PCallHandler <NSObject>

- (RXPromise *)startWithUserId:(NSString *)userId;
- (RXPromise *)callUserWithId:(NSString *)userId;
- (id<PCall>)activeCall;
- (id<PCall>)incomingCall;
- (void)answerIncomingCall;
- (void)hangupIncomingCall;
- (void)hangupActiveCall;

- (UIView *)localView;
- (UIView *)remoteView;

- (void)enableSpeaker;
- (void)disableSpeaker;

- (int)captureDevicePosition;
- (void)setCaptureDevicePosition:(int)i;
- (void)toggleCaptureDevicePosition;

- (UINavigationController *)callNavigationController;
- (UINavigationController *)incomingCallNavigationController;
- (UIViewController *)callViewController;
- (UIViewController *)incomingCallViewController;
- (void)setCallViewControllerClass:(Class)controllerClass;
- (void)setIncomingCallViewControllerClass:(Class)controllerClass;

@end

#endif /* PCallHandler_h */
