//
//  UIViewController+Additions.m
//  ChatSDK
//
//  Created by ben3 on 23/11/2020.
//

#import "UIViewController+Additions.h"
#import <ChatSDK/Core.h>

@implementation UIViewController(Additions)

-(void) alertWithTitle: (NSString *) title withError: (NSError *) error {
    [self alertWithTitle:title withMessage:error.localizedDescription];
}

-(void) alertWithTitle: (NSString *) title withMessage: (NSString *) message {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    __weak __typeof(self) weakSelf = self;
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:[NSBundle t:bOk] style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    }];

    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:Nil];
}

-(void) alertWithTitle: (NSString *) title withMessage: (NSString *) message actions: (NSArray<UIAlertAction *> *) actions {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    __weak __typeof(self) weakSelf = self;
    for(UIAlertAction * action in actions) {
        [alert addAction:action];
    }

    UIAlertAction * cancel = [UIAlertAction actionWithTitle:[NSBundle t:bCancel] style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
    }];

    [alert addAction:cancel];

    [self presentViewController:alert animated:YES completion:Nil];
}

@end
