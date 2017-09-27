//
//  BUserPopupView.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 25/08/2017.
//
//

#import <ChatSDKUI/ChatUI.h>
#import <Hakawai/HKWMentionsPlugin.h>

// This view is a popup view above the text input view, we provide it an array of users
// It then pops to that size and returns a user if clicked
@interface BMentionTextInputView : BTextInputView <UITextViewDelegate, HKWCustomChooserViewDelegate, HKWMentionsDelegate> {
    NSMutableArray * _users;
    NSMutableArray * _adaptedUsers;
    
    NSMutableArray * _userKeys;
    
    UIView * _chooserView;
    
    NSInteger _keyboardHeight;
}

@property (nonatomic, weak) id<HKWCustomChooserViewDelegate> delegate;

@property (nonatomic, strong) IBOutlet HKWTextView * textView;
@property (nonatomic, strong) HKWMentionsPlugin * plugin;

@end
