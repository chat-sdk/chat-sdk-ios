//
//  BContactBookModule.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/04/2017.
//
//

#import "BKeyboardOverlayOptionsModule.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>
#import "BChatOptionsCollectionView.h"

@implementation BKeyboardOverlayOptionsModule

-(void) activate {
    [BChatSDK.ui setChatOptionsHandler: [[BChatOptionsCollectionView alloc] init]];
}

@end
