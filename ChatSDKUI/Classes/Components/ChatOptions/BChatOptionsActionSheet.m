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
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:[NSBundle t:bOptions]
                                                              delegate:self
                                                     cancelButtonTitle:[NSBundle t:bOk]
                                                destructiveButtonTitle:Nil
                                                     otherButtonTitles:Nil];
    
    if (_options.count) {
        for (BChatOption * option in _options) {
            [actionSheet addButtonWithTitle:option.title];
        }
        [actionSheet showInView:_delegate.currentViewController.view];
    }
    else {
        // TODO: hide the option button
    }
    return NO;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex) {
        BChatOption * option = _options[buttonIndex - 1];
        [option execute:_delegate.currentViewController threadEntityID:_delegate.threadEntityID];
    }
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
    
}


@end
