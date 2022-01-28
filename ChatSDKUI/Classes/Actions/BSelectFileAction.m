//
//  BSelectFileAction.m
//  ChatSDK
//
//  Created by Pepe Becker on 19.04.18.
//

#import "BSelectFileAction.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@implementation BSelectFileAction

@synthesize name;
@synthesize mimeType;
@synthesize data;

@synthesize controller = _controller;
@synthesize picker = _picker;

-(instancetype) initWithViewController:(UIViewController *)controller {
    if ((self = [self init])) {
        _controller = controller;
    }
    return self;
}


-(instancetype) init {
    if ((self = [super init])) {
        _types = @[@"public.data"];
    }
    return self;
}

- (RXPromise *)execute {
    return [self execute:self.controller];
}

- (RXPromise *)execute: (UIViewController *) controller {

    if (!_promise) {
        _promise = [RXPromise new];
    }
    
    if (!_picker) {
        _picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:_types inMode:UIDocumentPickerModeImport];
        _picker.modalPresentationStyle = UIModalPresentationFormSheet;
        _picker.delegate = self;
    }

    __weak __typeof(self) weakSelf = self;
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [controller presentViewController:weakSelf.picker animated:YES completion:nil];
    }];

    return _promise;
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    [BChatSDK.shared.logger log: @"DocumentPicker picked document at url: %@", url];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    NSError * error = nil;
    NSURLResponse * response = nil;
    self.data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if (error == nil) {
        if (data && response) {
            self.url = url;
            self.name = [response suggestedFilename];
            self.mimeType = [response MIMEType];
            [_promise resolveWithResult:nil];
        } else {
            [_promise rejectWithReason:nil];
        }
    } else {
        [_promise rejectWithReason:error];
    }
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    [BChatSDK.shared.logger log: @"DocumentPicker cancelled"];
    [_promise rejectWithReason:nil];
}

@end
