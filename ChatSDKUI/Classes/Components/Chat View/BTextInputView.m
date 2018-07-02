//
//  BTextInputView.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 25/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BTextInputView.h"
#import <ChatSDK/Core.h>

#define bMargin 8.0

// The amount of padding (above + below) the text
// i.e. textView height = text height + padding
#define bTextViewVerticalPadding 5.72

#define bFontSize 19
#define bMaxLines 5
#define bMinLines 1

@implementation BTextInputView

@synthesize textView = _textView;
@synthesize maxLines, minLines;
@synthesize sendBarDelegate = _sendBarDelegate;
@synthesize optionsButton = _optionsButton;
@synthesize sendButton = _sendButton;
@synthesize placeholderLabel = _placeholderLabel;

-(instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
//        self.barTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
        self.backgroundColor = [UIColor whiteColor];
        
        // Decide how many lines the message should have
        minLines = bMinLines;
        maxLines = bMaxLines;
        
        // Set the text color
        _placeholderColor = [UIColor darkGrayColor];
        _textColor = [UIColor blackColor];

        // Create an options button which shows an action sheet
        _optionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_optionsButton];

        _textView = [[HKWTextView alloc] init];
        // If we use the mentions functionality we need to set the external delegate
        // This is the way to set the UITextView delegate to keep mentions functionality working
        _textView.simpleDelegate = self;
      
        [self addSubview: _textView];

        // Add a send button
        _sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self addSubview: _sendButton];
        
        [_optionsButton setImage:[NSBundle uiImageNamed:@"icn_24_options.png"] forState:UIControlStateNormal];
        [_optionsButton setImage:[NSBundle uiImageNamed:@"icn_24_keyboard.png"] forState:UIControlStateSelected];
        
        [_optionsButton addTarget:self action:@selector(optionsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        NSString * sendButtonTitle = [NSBundle t:bSend];
        [_sendButton setTitle:sendButtonTitle forState:UIControlStateNormal];
        
        [_sendButton addTarget:self action:@selector(sendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [_sendButton addTarget:self action:@selector(sendButtonHeld) forControlEvents:UIControlEventTouchDown];
        
        // We don't want to send a message if they touch up outside the button area
        [_sendButton addTarget:self action:@selector(sendButtonCancelled) forControlEvents:UIControlEventTouchUpOutside];
        
        _textView.scrollEnabled = YES;
        _textView.backgroundColor = [UIColor clearColor];
        
        // For some reason using scrollEnabled = NO causes probalems
        _textView.bounces = NO;
        
        // Adjust the insets to make the text closer to the outside of the
        // box - ios6 is slightly different from ios7
        if ([UIDevice currentDevice].systemVersion.intValue < 7) {
            _textView.contentInset = UIEdgeInsetsMake(-6.0, -4.0, -6.0, 0.0);
        }
        else {
            _textView.contentInset = UIEdgeInsetsMake(-6.0, -1.0, -6.0, 0.0);
        }

        // Constrain the elements
        _optionsButton.keepLeftInset.equal = bMargin +keepRequired;

        _optionsButton.keepBottomInset.equal = 8.0;
        _optionsButton.keepHeight.equal = 24;
        
        // If the user has no chat options available then remove the chat option button width
        _optionsButton.keepWidth.equal = [BInterfaceManager sharedManager].a.chatOptions.count ? 24 : 0;
        
        _optionsButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        _sendButton.keepRightInset.equal = bMargin;
        _sendButton.keepBottomInset.equal = 0;
        _sendButton.keepHeight.equal = 40;
        _sendButton.keepWidth.equal = 48;
        _sendButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        _textView.keepLeftOffsetTo(_optionsButton).equal = bMargin;
        _textView.keepRightOffsetTo(_sendButton).equal = bMargin;
        _textView.keepBottomInset.equal = bMargin;
        _textView.keepTopInset.equal = bMargin;
        _textView.translatesAutoresizingMaskIntoConstraints = NO;

        // Create a placeholder text label
        _placeholderLabel = [[UILabel alloc] init];
        [self addSubview:_placeholderLabel];
        
        _placeholderLabel.keepBottomInset.equal = 0;
        _placeholderLabel.keepTopInset.equal = 0;
        _placeholderLabel.keepLeftOffsetTo(_optionsButton).equal = bMargin + 4;
        _placeholderLabel.keepWidth.equal = 200;
        [_placeholderLabel setBackgroundColor:[UIColor clearColor]];
        
        [_placeholderLabel setTextColor:_placeholderColor];
        
        [_placeholderLabel setText:[NSBundle t:bWriteSomething]];
        
        [self setFont:[UIFont systemFontOfSize:bFontSize]];
        
        // Check this
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInterfaceForReachabilityStateChange) name:kReachabilityChangedNotification object:Nil];
        
        [self updateInterfaceForReachabilityStateChange];
        
        UIView * topMarginView = [[UIView alloc] initWithFrame:CGRectZero];
        topMarginView.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:topMarginView];
        
        topMarginView.keepTopInset.equal = 0 + keepRequired;
        topMarginView.keepLeftInset.equal = 0 + keepRequired;
        topMarginView.keepRightInset.equal = 0 + keepRequired;
        topMarginView.keepHeight.equal = 0.5 + keepRequired;
        
        [self resizeToolbar];
    }
    return self;
}

-(void) updateInterfaceForReachabilityStateChange {
    BOOL connected = [Reachability reachabilityForInternetConnection].isReachable;
    _sendButton.enabled = connected;
    _optionsButton.enabled = connected;
}

-(void) setAudioEnabled: (BOOL) audioEnabled {
    _audioEnabled = audioEnabled;
    [self setMicButtonEnabled:_audioEnabled];
}

-(void) setMicButtonEnabled: (BOOL) enabled {
    _micButtonEnabled = enabled;
    if (enabled) {
        [_sendButton setTitle:Nil forState:UIControlStateNormal];
        [_sendButton setImage:[NSBundle uiImageNamed: @"icn_24_mic.png"]
                     forState:UIControlStateNormal];
    }
    else {
        [_sendButton setTitle:[NSBundle t:bSend] forState:UIControlStateNormal];
        [_sendButton setImage:Nil forState:UIControlStateNormal];
    }
}

#pragma Button Delegates

-(void) sendButtonPressed {
    
    
    if (_audioMaxLengthReached) {
        _audioMaxLengthReached = NO;
        return;
    }

    [self stopRecording];

    if (!_micButtonEnabled) {
        
        // Check if the message is empty
        if ([[_textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            return;
        }
        
        if (_sendBarDelegate && [_sendBarDelegate respondsToSelector:@selector(sendTextMessage:)]) {
            [_sendBarDelegate sendTextMessage:_textView.text];
        }
        _textView.text = @"";
        [self textViewDidChange:_textView];
    }
    else {
        [self sendAudioMessage];
    }
}

// When the button is held we start recording
- (void)sendButtonHeld {
    if (_micButtonEnabled) {
        [[BAudioManager sharedManager] startRecording];
        _recordingToastTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                target:self
                                                              selector:@selector(showRecordingToast)
                                                              userInfo:Nil
                                                               repeats:YES];
        _recordingStart = [NSDate new];
        [_placeholderLabel setText:[NSBundle t: bSlideToCancel]];
    }
}

-(void) sendAudioMessage {
    // This is where the button is released so we want to finish recording and send
    if (_sendBarDelegate && [_sendBarDelegate respondsToSelector:@selector(sendAudioMessage:duration:)]) {
        
        // Return the recording url and duration in an array
        NSURL * audioURL = [BAudioManager sharedManager].recorder.url;
        NSData * audioData = [NSData dataWithContentsOfURL:audioURL];
        
        [_sendBarDelegate sendAudioMessage: audioData
                                  duration: [BAudioManager sharedManager].recordingLength];
    }
}

-(void) showRecordingToast {
    NSString * text = [NSBundle t:bRecording];
    
    int remainingTime = BChatSDK.config.audioMessageMaxLengthSeconds + [_recordingStart timeIntervalSinceNow];
    if (remainingTime <= 10) {
        text = [NSString stringWithFormat:[NSBundle t: bSecondsRemaining_], remainingTime];
    }
    if (remainingTime <= 0) {
        _audioMaxLengthReached = YES;
        [self stopRecording];
        [self presentAlertView];
    }
    [_sendBarDelegate.view makeToast:text
                            duration:0.7
                            position:[NSValue valueWithCGPoint: CGPointMake(_sendBarDelegate.view.frame.size.width / 2.0, self.frame.origin.y - self.frame.size.height - 20)]];
}

-(void) stopRecording {
    [[BAudioManager sharedManager] finishRecording];
    [_sendBarDelegate.view hideAllToasts];
    [_placeholderLabel setText:[NSBundle t:bWriteSomething]];
    [self cancelRecordingToastTimer];
}

-(void) presentAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSBundle t:bAudioLengthLimitReached]
                                                                   message:[NSBundle t:bSendOrDiscardRecording]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *submit = [UIAlertAction actionWithTitle:[NSBundle t:bSend] style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [self sendAudioMessage];
                                                   }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:[NSBundle t:bCancel] style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:submit];
    [alert addAction:cancel];
    
    [self.sendBarDelegate.viewController presentViewController:alert animated:YES completion:Nil];

}

-(void) cancelRecordingToastTimer {
    if(_recordingToastTimer) {
        [_recordingToastTimer invalidate];
        _recordingToastTimer = Nil;
        _recordingStart = Nil;
    }
}

// If the user touches up off the button we cancel the recording
- (void)sendButtonCancelled {
    [_sendBarDelegate.view hideAllToasts];
    [_placeholderLabel setText:[NSBundle t:bWriteSomething]];
    CSToastStyle * style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [UIColor redColor];
    [_sendBarDelegate.view makeToast:[NSBundle t:bCancelled]
                            duration:1
                            position:[NSValue valueWithCGPoint: CGPointMake(_sendBarDelegate.view.frame.size.width / 2.0, self.frame.origin.y - self.frame.size.height - 20)] style:style];
    [self cancelRecordingToastTimer];
    [[BAudioManager sharedManager] finishRecording];
}

-(void) optionsButtonPressed {
    BOOL select = NO;
    if (_optionsButton.selected) {
        if (_sendBarDelegate && [_sendBarDelegate respondsToSelector:@selector(showOptions)]) {
            select = [_sendBarDelegate hideOptions];
        }
    }
    else {
        if (_sendBarDelegate && [_sendBarDelegate respondsToSelector:@selector(showOptions)]) {
            select = [_sendBarDelegate showOptions];
        }
    }
    if(select) {
        _optionsButton.selected = !_optionsButton.selected;
    }
}

-(void) setFont: (UIFont *) font {
    [_textView setFont:font];
    [_placeholderLabel setFont:font];
    [self resizeToolbar];
}

-(float) getTextBoxTextHeight {
    NSString * text = _textView.text;
    
    
    // If it ends in a new line this isn't included in the size so add an extra character
    if ([text hasSuffix:@"\n"] || [text isEqualToString:@""]) {
        text = [text stringByAppendingString:@"-"];
    }
    
    return [self getTextHeight:text];
}

-(float) getTextHeight: (NSString *) text {
    return [text boundingRectWithSize:CGSizeMake(_textView.contentSize.width - 1, CGFLOAT_MAX)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName: _textView.font}
                                   context:Nil].size.height;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    // Typing Indicator
    if (_sendBarDelegate && [_sendBarDelegate respondsToSelector:@selector(typing)]) {
        [_sendBarDelegate typing];
    }
    
    // Workout if adding this text will cause the box to become too long
    NSString * newText = [textView.text stringByAppendingString:text];
    
    NSInteger numberOfLines = [self getTextHeight:newText]/textView.font.lineHeight;
    numberOfLines = MAX(numberOfLines, [newText componentsSeparatedByString:@"\n"].count);
    
    if (numberOfLines > maxLines) {
        return NO;
    }
    
    else return YES;
}

-(void) textViewDidChange:(UITextView *)textView {
    
    // If there is text or if the audio is turned off
    if (textView.text.length || !_audioEnabled) {
        [self setMicButtonEnabled:NO];
    }
    else {
        [self setMicButtonEnabled:YES];
    }
    
    
    [self resizeToolbar];

    // If the text area is empty show the placeholder
    _placeholderLabel.hidden = ![textView.text isEqualToString:@""];
}

-(void) resizeToolbar {
    
    float originalHeight = self.keepHeight.equal;
    
//    float newHeight = MAX(_textView.contentSize.height, _textView.font.lineHeight);//[self getTextBoxTextHeight];
    float newHeight = MAX(_textView.font.lineHeight, [self measureHeightOfUITextView:_textView]);
    
    // Calcualte the new textview height
    float textBoxHeight = newHeight + bTextViewVerticalPadding;

    // Set the toolbar height - the text view will resize automatically
    // using autolayout
    self.keepHeight.equal = bMargin * 2 + textBoxHeight;
    
    float delta = self.keepHeight.equal - originalHeight;
    
    if(fabsf(delta) > 0.01) {
        [self.superview setNeedsUpdateConstraints];
        
        __weak __typeof__(self) weakSelf = self;
        
        [UIView animateWithDuration:0.2 animations:^{
            __typeof__(self) strongSelf = weakSelf;
            
            //[self setNeedsUpdateConstraints];
            [strongSelf.superview layoutIfNeeded];
            [strongSelf->_textView setContentOffset:CGPointZero animated:NO];

            if(strongSelf->_sendBarDelegate != Nil) {
                [strongSelf->_sendBarDelegate didResizeTextInputViewWithDelta:delta];
            }
        }];
    }
}

- (CGFloat)measureHeightOfUITextView:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
    }
    else
    {
        return textView.contentSize.height;
    }
}

-(void) setOptionsButtonHidden: (BOOL) hidden {
    _optionsButton.keepWidth.equal = hidden ? 0 : 24;
}

-(BOOL) resignTextViewFirstResponder {
//    [super resignFirstResponder];
    return [_textView resignFirstResponder];
}

-(void) becomeTextViewFirstResponder {
//    [super becomeFirstResponder];
    [_textView becomeFirstResponder];
}

-(void) setSendBarDelegate:(id<PSendBarDelegate>)delegate {
    _sendBarDelegate = delegate;
}

@end
