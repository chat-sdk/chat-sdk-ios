//
//  BGoogleLoginViewController.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 03/03/2017.
//
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>
#import "BGoogleLoginDelegate.h"

@interface BGoogleLoginViewController : UIViewController <GIDSignInDelegate, GIDSignInUIDelegate> {
    
}

//@property (nonatomic, weak) BGoogleLoginDelegate * googleDelegate;

//@property (nonatomic, weak) id<TheProtocolName> delegate

@property (nonatomic, weak) RXPromise * googleLoginPromise;

// Property of delegate
// The helper has view.delegate = self
// [self.delegate googleLoginWasSuccessful

@end

