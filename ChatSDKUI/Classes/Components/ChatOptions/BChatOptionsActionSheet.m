//
//  BChatOptionsActionSheet.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/12/2016.
//
//

#import "BChatOptionsActionSheet.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

@implementation BChatOptionsActionSheet

-(instancetype) initWithChatViewController: (BChatViewController *) chatViewController {
    if((self = [self init])) {
        _chatViewController = chatViewController;
        
        _options = [BInterfaceManager sharedManager].a.chatOptions;
        
        for(BChatOption * o in _options) {
            o.parent = self;
        }
        
    }
    return self;
}

-(BOOL) show {
    [_chatViewController hideKeyboard];
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:[NSBundle t:bOptions]
                                                              delegate:self
                                                     cancelButtonTitle:[NSBundle t:bOk]
                                                destructiveButtonTitle:Nil
                                                     otherButtonTitles:Nil];
    
    if (_options.count) {
        for (BChatOption * option in _options) {
            [actionSheet addButtonWithTitle:option.title];
        }
        [actionSheet showInView:_chatViewController.view];
    }
    else {
        // TODO: hide the option button
    }
    return NO;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex) {
        BChatOption * option = _options[buttonIndex - 1];
        [_delegate chatOptionActionExecuted:[option execute]];
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

-(void) setOptionsDelegate:(id<BChatOptionDelegate>)delegate {
    self.delegate = delegate;
}

@end
