//
//  BLogger.m
//  ChatSDK
//
//  Created by ben3 on 29/09/2020.
//

#import "BLogger.h"
#import <ChatSDK/Core.h>

@implementation BLogger {
    dispatch_queue_main_t _queue;
}

-(instancetype) init {
    if((self = [super init])) {
        _queue = dispatch_queue_create("LogQueue", NULL);
    }
    return self;
}

-(void)remoteLog: (NSString *) message {
    
}


//-(void) log: (NSString *) text {
//    NSLog(text);
//    _transcript = [_transcript stringByAppendingFormat:@"%@ \n\n"];
//}

-(void)log: (NSString *)format, ... {
    if (BChatSDK.config.debugModeEnabled) {
        va_list args;
        va_start(args, format);
        NSString * val = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);

        dispatch_async(_queue, ^{

        //    dispatch_async(dispatch_get_main_queue(), ^{
                if (!_log) {
                    _log = @"\n===\nLog\n===\n\n\n";
                }
                _log = [_log stringByAppendingFormat:@"%@ %@ \n\n", [NSDate date], val];
                NSLog(@"%@", val);
        //    });
        });
    }
}

-(void)publicLog: (NSString *)format, ... {
    if (BChatSDK.config.debugModeEnabled) {
        va_list args;
        va_start(args, format);
        NSString * val = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);

        dispatch_async(_queue, ^{

        //    dispatch_async(dispatch_get_main_queue(), ^{
                if (!_publicTranscript) {
                    _publicTranscript = [NSMutableArray new];
                }
                if (!_publicLog) {
                    _publicLog = @"\n===\nPub\n===\n\n\n";
                }

                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"HH:mm:ss";

                [_publicTranscript addObject:[NSString stringWithFormat:@"%@ %@ \n\n", [formatter stringFromDate:NSDate.date], val]];
                _publicLog = [_publicLog stringByAppendingFormat:@"%@ %@ \n\n", [formatter stringFromDate:NSDate.date], val];
        //    });
        });
    }
}

@end
