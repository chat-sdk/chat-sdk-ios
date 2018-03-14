//
//  BEditProfileTableViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 25/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CountryPicker/CountryPicker.h>

#ifdef __IPHONE_8_0
#define GregorianCalendar NSCalendarIdentifierGregorian
#else
#define GregorianCalendar NSGregorianCalendar
#endif

@interface BEditProfileTableViewController : UITableViewController<UITextViewDelegate> {
    UITapGestureRecognizer * _tapRecognizer;
    BOOL _didLogout;
    id _keyboardObserver;
    float _statusTextViewHeight;
}

@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentControl;
@property (weak, nonatomic) IBOutlet CountryPicker *countryPickerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *allowInvitesFromSegmentControl;
@property (nonatomic, readonly) BOOL didLogout;

@end
