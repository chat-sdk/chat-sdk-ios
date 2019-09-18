//
//  BSelectFileAction.h
//  ChatSDK
//
//  Created by Pepe Becker on 19.04.18.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PAction.h>

@class RXPromise;

@interface BSelectFileAction : NSObject<PAction, UIDocumentPickerDelegate> {
    UIDocumentPickerViewController * _picker;
    RXPromise * _promise;
    NSArray * _types;
    __weak UIViewController * _controller;
}

@property (nonatomic, readwrite) NSString * name;
@property (nonatomic, readwrite) NSString * mimeType;
@property (nonatomic, readwrite) NSData * data;
@property (nonatomic, readwrite) NSURL * url;

- (instancetype)initWithViewController:(UIViewController *)controller;

@end
