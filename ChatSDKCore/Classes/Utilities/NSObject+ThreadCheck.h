//
//  NSObject+ThreadCheck.h
//  ChatSDK
//
//  Created by ben3 on 03/11/2020.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject(ThreadCheck)

-(void) checkOnMain;

@end

NS_ASSUME_NONNULL_END
