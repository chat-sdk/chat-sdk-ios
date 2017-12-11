//
//  PChatOptionsView.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/12/2016.
//
//

#ifndef PChatOptionsHandler_h
#define PChatOptionsHandler_h

#import <ChatSDK/BChatOptionDelegate.h>

@class BChatViewController;

@protocol PChatOptionsHandler <NSObject>

@optional

-(instancetype) initWithChatViewController: (BChatViewController *) chatViewController;

-(BOOL) show;
-(BOOL) hide;
-(void) setOptionsDelegate: (id<BChatOptionDelegate>) delegate;
-(id<BChatOptionDelegate>) delegate;
-(UIView *) keyboardView;
-(void) presentView: (UIView *) view;
-(void) dismissView;

@end


#endif /* PChatOptionsView_h */
