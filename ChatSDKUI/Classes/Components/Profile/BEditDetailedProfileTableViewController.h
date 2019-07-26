//
//  BEditProfileTableViewController.h
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 25/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CountryPicker/CountryPicker.h>
#import <StaticDataTableViewController/StaticDataTableViewController.h>

#ifdef __IPHONE_8_0
#define GregorianCalendar NSCalendarIdentifierGregorian
#else
#define GregorianCalendar NSGregorianCalendar
#endif

@class BDetailedProfileTableViewController;

@interface BDetailedEditProfileTableViewController : StaticDataTableViewController<CountryPickerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UITapGestureRecognizer * _tapRecognizer;
    id _keyboardObserver;
    float _statusTextViewHeight;
    UIImagePickerController * _imagePicker;
    NSArray * _availabilityOptions;
    UIImage * _profileImage;
}

@property (nonatomic, readwrite) BDetailedProfileTableViewController * profileViewController;

@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *localityTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *availabilityPicker;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *availabilityButton;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UIButton *profilePictureButton;

@property (weak, nonatomic) IBOutlet UITableViewCell *availabilityCell;

@property (weak, nonatomic) IBOutlet CountryPicker *countryPickerView;

@property (weak, nonatomic) IBOutlet UITableViewCell *nameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *localityCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *phoneCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *countryButtonCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *countryPickerCell;

@property (weak, nonatomic) IBOutlet UITableViewCell *clearLocalDataCell;


@end
