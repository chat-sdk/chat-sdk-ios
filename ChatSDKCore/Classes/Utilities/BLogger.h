//
//  BLogger.h
//  ChatSDK
//
//  Created by ben3 on 29/09/2020.
//

#import <Foundation/Foundation.h>
#import "PLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLogger: NSObject<PLogger>

@property (nonatomic, readwrite) NSString * log;
@property (nonatomic, readwrite) NSString * publicLog;
@property (nonatomic, readwrite) NSMutableArray<NSString *> * publicTranscript;

@end

NS_ASSUME_NONNULL_END
