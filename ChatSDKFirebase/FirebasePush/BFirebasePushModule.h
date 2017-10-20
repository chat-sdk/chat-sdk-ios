//
//  BFirebasePushHandlerModule.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 03/08/2017.
//  Copyright © 2017 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BFirebasePushModule : NSObject

-(void) activateForFirebaseWithApplication: (UIApplication *) application withOptions: (NSDictionary *) launchOptions ;
-(void) activateForXMPPWithApplication: (UIApplication *) application withOptions: (NSDictionary *) launchOptions;

@end
