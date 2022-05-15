//
//  BAudioMessageCell.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 06/08/2015.
//
//

#import <ChatSDK/BMessageCell.h>

#define bAudioMessageCell @"AudioMessageCell"


// TODO: Check which of these are needed when we merge in
@interface BAudioMessageCell : BMessageCell {
    
    UIButton * _playButton;
    UIImageView * _soundWaveImageView;
    UILabel * _audioLengthLabel;
    UILabel * _currentTimeLabel;
    UISlider * _slider;
    UIActivityIndicatorView * _streamingActivityIndicator;

    NSTimer * _uiUpdateTimer;
    
    float _totalTime;
}

@property (nonatomic, readwrite) UIImageView * imageView;

@end


