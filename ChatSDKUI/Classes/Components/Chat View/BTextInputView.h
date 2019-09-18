//
//  BTextInputView.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 25/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChatSDK/PSendBarDelegate.h>
#import <ChatSDK/PSendBar.h>
#import <ChatSDK/bChatState.h>
#import <ChatSDK/UI.h>

@class BHook;

@interface BTextInputView : UIView<UITextViewDelegate, PSendBar> {
    UIButton * _optionsButton;
    UILabel * _placeholderLabel;
    UIColor * _placeholderColor;
    UIColor * _textColor;
    
    NSTimer * _recordingToastTimer;
    
    BOOL _audioEnabled;
    BOOL _micButtonEnabled;
    NSDate * _recordingStart;
    BOOL _audioMaxLengthReached;
    
    BHook * _internetConnectionHook;
}

@property (weak, nonatomic, readwrite) id<PSendBarDelegate> sendBarDelegate;
// This is a property so we can access it from our mentions view
@property (nonatomic, readwrite) HKWTextView * textView;

@property (nonatomic, readwrite) NSInteger maxCharacters;
@property (nonatomic, readwrite) NSInteger maxLines;
@property (nonatomic, readwrite) NSInteger minLines;
@property (nonatomic, readwrite) UIButton * optionsButton;
@property (nonatomic, readwrite) UIButton * sendButton;
@property (nonatomic, readonly) UILabel * placeholderLabel;

-(void) setAudioEnabled: (BOOL) audioEnabled;
-(BOOL) resignTextViewFirstResponder;
-(void) becomeTextViewFirstResponder;
-(void) setOptionsButtonHidden: (BOOL) hidden;
-(void) setMicButtonEnabled: (BOOL) enabled;

@end
