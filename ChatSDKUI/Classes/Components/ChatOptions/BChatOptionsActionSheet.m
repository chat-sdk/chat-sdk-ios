//
//  BChatOptionsActionSheet.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/12/2016.
//
//

#import "BChatOptionsActionSheet.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation BChatOptionsActionSheet

-(instancetype) initWithDelegate: (id<BChatOptionDelegate>) delegate {
    if((self = [self init])) {
        self.delegate = delegate;
        
        _options = BChatSDK.ui.chatOptions;
                
    }
    return self;
}

-(BOOL) show {
    [_delegate hideKeyboard];
    
    // We want to create an action sheet which will allow users to choose how they add their contacts
    UIAlertController * view = [UIAlertController alertControllerWithTitle:[NSBundle t:bOptions] message:Nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIView * parentView = _delegate.currentViewController.view;
    
    view.modalPresentationStyle = UIModalPresentationPopover;
    view.popoverPresentationController.sourceRect = CGRectMake(50, parentView.bounds.size.height - 80, 200, 200);
//    view.popoverPresentationController.permittedArrowDirections = @[];
    view.popoverPresentationController.sourceView = _delegate.currentViewController.view;
    
    if (_options.count) {
        for (BChatOption * option in _options) {
            UIAlertAction * action = [UIAlertAction actionWithTitle:option.title
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * action) {
                [option execute:_delegate.currentViewController threadEntityID:_delegate.threadEntityID handler:nil];
            }];
            [view addAction:action];
        }
        UIAlertAction * action = [UIAlertAction actionWithTitle:[NSBundle t:bCancel]
                                                              style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * action) {
            [self dismissView];
        }];
        [view addAction:action];

        [_delegate.currentViewController presentViewController:view animated:YES completion:nil];
    }

    return NO;
}

-(UIView *) keyboardView {
    return Nil;
}

-(BOOL) hide {
    return NO;
}

-(void) presentView: (UIView *) view {
    
}

-(void) dismissView {
    [_delegate.currentViewController dismissViewControllerAnimated:YES completion:Nil];
}


@end
