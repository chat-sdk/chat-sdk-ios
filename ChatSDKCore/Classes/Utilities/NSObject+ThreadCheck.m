//
//  NSObject+ThreadCheck.m
//  ChatSDK
//
//  Created by ben3 on 03/11/2020.
//

#import "NSObject+ThreadCheck.h"

@implementation NSObject(ThreadCheck)

-(void) checkOnMain {
    if (!NSThread.currentThread.isMainThread) {
        NSLog(@"Not on main");
    }
}

@end
