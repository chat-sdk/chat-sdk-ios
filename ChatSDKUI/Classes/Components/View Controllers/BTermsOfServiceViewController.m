//
//  BTermsOfServiceController.m
//  ChatSDK
//
//  Created by Pepe Becker on 01/03/2019.
//  Copyright © 2019 Pepe Becker. All rights reserved.
//

#import "BTermsOfServiceViewController.h"

#import <ChatSDK/UI.h>

@implementation BTermsOfServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.navigationItem) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bBack] style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    }
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    _webView.keepInsets.equal = 0 + keepRequired;

    [self load];
}

- (void)load {
    if (BChatSDK.config.termsOfServiceURL) {
        NSURL * url = [NSURL URLWithString:BChatSDK.config.termsOfServiceURL];
        if (url) {
            NSURLRequest * request = [NSURLRequest requestWithURL:url];
            if (request) {
                [_webView loadRequest:request];
            }
        }
    }
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
