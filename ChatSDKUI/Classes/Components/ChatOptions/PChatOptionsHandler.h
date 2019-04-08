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

-(instancetype) initWithDelegate: (id<BChatOptionDelegate>) delegate;

// Show or hide the options view
-(BOOL) show;
-(BOOL) hide;

// Set the delegate aka chat view controller
-(void) setDelegate: (id<BChatOptionDelegate>) delegate;

// Get the view to be displayed in the keyboard area
-(UIView *) keyboardView;

// Present or hide view within keyboard view
-(void) presentView: (UIView *) view;
-(void) dismissView;

@end


#endif /* PChatOptionsView_h */
