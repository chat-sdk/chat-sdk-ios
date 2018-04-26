//
//  BSelectLocationAction.m
//  ChatSDK
//
//  Created by Ben on 12/11/17.
//

#import "BSelectLocationAction.h"
#import <ChatSDK/ChatCore.h>

@interface BSelectLocationAction() {
    RXPromise * _promise;
    __weak UIViewController * _controller;
    UINavigationController * _navController;
    BLocationPickerController * _picker;
}
@end

@implementation BSelectLocationAction

- (instancetype)initWithViewController:(UIViewController *)controller {
    if ((self = [self init])) {
        _controller = controller;
    }
    return self;
}

- (RXPromise *)execute {
    _promise = [RXPromise new];
    
    if (!_picker) {
        _picker = [[BLocationPickerController alloc] init];
        _picker.delegate = self;
    }

    if (!_navController) {
        _navController = [[UINavigationController alloc] initWithRootViewController:_picker];
    }

    [_controller presentViewController:_navController animated:YES completion:nil];

    return _promise;
}

- (void)locationPickerController:(id)locationPicker didSelectLocation:(CLLocation *)location {
    [_promise resolveWithResult:location];
}

- (void)locationPickerControllerDidCancel:(id)locationPicker {
    [_promise rejectWithReason:nil];
}

@end
