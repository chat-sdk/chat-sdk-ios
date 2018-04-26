//
//  BLocationPickerController.h
//  ChatSDK
//
//  Created by Pepe Becker on 24.04.18.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol BLocationPickerControllerDelegate <NSObject>

- (void)locationPickerController:(id)locationPicker didSelectLocation:(CLLocation *)location;
- (void)locationPickerControllerDidCancel:(id)locationPicker;

@end

@interface BLocationPickerController : UIViewController

@property (nonatomic, weak) id <BLocationPickerControllerDelegate> delegate;

@end
