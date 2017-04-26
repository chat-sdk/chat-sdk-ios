//
//  BChatOptionsActionSheet.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 18/12/2016.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDKUI/PChatOptionsHandler.h>
#import <ChatSDKUI/BChatOptionDelegate.h>

@class BChatViewController;
@protocol BChatViewController;

@interface BChatOptionsActionSheet : NSObject<PChatOptionsHandler, UIActionSheetDelegate> {
    NSMutableArray * _options;
    __weak BChatViewController * _chatViewController;
}

@property (nonatomic, readwrite, weak) id<BChatOptionDelegate> delegate;

@end
