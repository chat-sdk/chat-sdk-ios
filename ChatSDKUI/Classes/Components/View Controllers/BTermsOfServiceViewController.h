//
//  BTermsOfServiceViewController.h
//  ChatSDK
//
//  Created by Pepe Becker on 01/03/2019.
//  Copyright © 2019 Pepe Becker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BTermsOfServiceViewController : UIViewController

@property (nonatomic, strong) WKWebView * webView;

- (void)load;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
