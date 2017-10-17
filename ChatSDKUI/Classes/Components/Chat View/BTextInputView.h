//
//  BTextInputView.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 25/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTextInputDelegate.h"
#import <ChatSDK/bChatState.h>
#import <ChatSDK/ChatUI.h>

@interface BTextInputView : UIView<UITextViewDelegate> {
    UIButton * _optionsButton;
    UILabel * _placeholderLabel;
    UIColor * _placeholderColor;
    UIColor * _textColor;
    
    BOOL _audioEnabled;
    BOOL _micButtonEnabled;
}

@property (weak, nonatomic, readwrite) id<BTextInputDelegate> messageDelegate;

// This is a property so we can access it from our mentions view
@property (nonatomic, readwrite) HKWTextView * textView;

@property (nonatomic, readwrite) NSInteger maxLines;
@property (nonatomic, readwrite) NSInteger minLines;
@property (nonatomic, readwrite) UIButton * optionsButton;
@property (nonatomic, readwrite) UIButton * sendButton;

-(void) setAudioEnabled: (BOOL) audioEnabled;
-(BOOL) resignFirstResponder;
-(void) becomeFirstResponder;
-(void) setOptionsButtonHidden: (BOOL) hidden;

@end
