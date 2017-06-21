//
//  BEditProfileTableViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 25/02/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//

#import "BEditProfileTableViewController.h"

#import <ChatSDKCore/ChatCore.h>
#import <ChatSDKUI/ChatUI.h>

#define bStatusSection 0

@interface BEditProfileTableViewController ()

@end

@implementation BEditProfileTableViewController

@synthesize statusTextView;
@synthesize nameTextField;
@synthesize locationTextField;
@synthesize genderSegmentControl;
@synthesize countryPickerView;
@synthesize dateOfBirthPicker;
@synthesize allowInvitesFromSegmentControl;
@synthesize didLogout = _didLogout;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _ages = [NSMutableArray new];
    
    //NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];//[NSCalendar calendarWithIdentifier:NSGregorianCalendar];
    //int year = [gregorian component:NSYearCalendarUnit fromDate:[NSDate date]];
    
    // NSDateFormatter to separate the Year and Month from currentDate
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy"];
    
    //NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    
    int year = [[df stringFromDate:[NSDate date]] integerValue];
    
    for (int i = year; i >= 1920; i--) {
        [_ages addObject:[NSString stringWithFormat:@"%i", i]];
    }
    
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:_tapRecognizer];
    
//    _keyboardObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:Nil usingBlock:^(NSNotification * n) {
//        [self updateUserAndIndexes];
//    }];
    
    // Update the user's details
    id<PUser> user = NM.currentUser;

    // Load the user's information
    statusTextView.text = [user metaStringForKey:bDescription];
    nameTextField.text = user.name;
    locationTextField.text = [user metaStringForKey:bLocation];
    
    NSString * gender = [user metaStringForKey:bGender];
    
    genderSegmentControl.selectedSegmentIndex = [gender isEqualToString:@"M"] ? 0 : 1 ;

    NSString * countryCode = [user metaStringForKey:bCountry];
    countryCode = countryCode ? countryCode : @"GB";
    
    [countryPickerView setSelectedCountryCode:countryCode animated:NO];

    //NSDate * date = user.dateOfBirth;

    //if (date) {
    //    [dateOfBirthPicker setDate:date];
    //}
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)countryPicker:(CountryPicker *)picker didSelectCountryWithName:(NSString *)name code:(NSString *)code {

}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _ages.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _ages[row];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // If we've just logged out then we don't want to do anything
    // because we won't have a Firebase permission
    if (_didLogout) {
        return;
    }
    // #6679 Start bug fix for v3.0.2
    [self updateUserAndIndexes];
    // End bug fix for v3.0.2
    
    //[[NSNotificationCenter defaultCenter] removeObserver:_keyboardObserver];
    
}

-(void) logout {
    
    [self.navigationController popViewControllerAnimated:NO];
    
    // This will prevent the app from trying to
    _didLogout = YES;
    [NM.auth logout];
    
    // Clear fields
    nameTextField.text = @"";
    locationTextField.text = @"";
}

-(void) viewTapped {
    // Resign first responder for all fields
    [nameTextField resignFirstResponder];
    [locationTextField resignFirstResponder];
    [statusTextView resignFirstResponder];
}

// #6679 Start bug fix for v3.0.2
-(void) updateUserAndIndexes {
    
    // Add the user to the index
    id<PUser> user = NM.currentUser;
    
    // Get the user's starting meta
    NSDictionary * oldMeta = user.model.metaDictionary;
    
    [user setMetaString:statusTextView.text forKey:bDescription];
    
    user.name = nameTextField.text;
    [user setMetaString:locationTextField.text forKey:bLocation];
    
    NSString * gender = genderSegmentControl.selectedSegmentIndex ? @"F" : @"M";
    [user setMetaString: gender forKey:bGender];
    [user setMetaString:countryPickerView.selectedCountryCode forKey:bCountry];

    NSString * dateOfBirth = [NSString stringWithFormat:@"%.0f", dateOfBirthPicker.date.timeIntervalSince1970 * 1000]; // Convert to miliseconds
    [user setMetaString:dateOfBirth forKey:bDateOfBirth];
    
    BOOL pushRequired = NO;
    for (NSString * key in user.model.metaDictionary) {
        if (![oldMeta[key] isEqual: user.model.metaDictionary[key]]) {
            pushRequired = YES;
            break;
        }
    }
    
    if (pushRequired) {
        [NM.core pushUser];
    }
    

        
//        [[BNetworkManager sharedManager].adapter updateIndexForUser:user].thenOnMain(Nil, ^id(NSError * error) {
//            [UIView alertWithTitle:bErrorTitle withError:error];
//            return error;
//        });
    

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
}

-(BOOL) hidesBottomBarWhenPushed {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == bStatusSection) {
        float height = statusTextView.heightToFitText + 16;
        height = MIN(height, 300);
        return height;
    }
    return [super tableView: tableView heightForRowAtIndexPath:indexPath];
}

-(void) textViewDidChange:(UITextView *)textView {
    float newHeight = [statusTextView heightToFitText];
    if (newHeight != _statusTextViewHeight) {
        _statusTextViewHeight = newHeight;
        
        [self.tableView reloadData];
        [statusTextView becomeFirstResponder];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString * newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (textView.heightToFitText >= 300 && newText.length > textView.text.length) {
        return NO;
    }
    return YES;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == bAccountSection && indexPath.row == bLogoutRow) {
//        [self logout];
//    }
//    if (indexPath.section == bUtilitySection && indexPath.row == bClearCacheRow) {
//        [[BCoreDataManager sharedManager] deleteAllData];
//    }
//}

- (IBAction)logoutButtonPressed:(id)sender {
    [self logout];
}

- (IBAction)clearLocalData:(id)sender {
    [self logout];
    [[BStorageManager sharedManager].a deleteAllData];
}

@end
