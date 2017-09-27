//
//  BTextInputView.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 25/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTextInputDelegate.h"
#import <ChatSDKCore/bChatState.h>
#import <Hakawai/HKWTextView.h>
#import <ChatSDKCore/ChatCore.h>

// These are in the header so our subclasses can access them
#define bMargin 4.0

// The amount of padding (above + below) the text
// i.e. textView height = text height + padding
#define bTextViewVerticalPadding 5.72

#define bFontSize 19
#define bMaxLines 5
#define bMinLines 1

@interface BTextInputView : UIView<UITextViewDelegate> {
    
    UIButton * _optionsButton;
    UILabel * _placeholderLabel;
    UIColor * _placeholderColor;
    UIColor * _textColor;
    
    BOOL _audioEnabled;
    BOOL _micButtonEnabled;
}

// We want a global thread property to allow the mention view to know the users in the current thread
// We add this here so we can access it in our MentionSubclass
@property (nonatomic, weak) id<PThread> thread;

@property (weak, nonatomic, readwrite) id<BTextInputDelegate> messageDelegate;

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
