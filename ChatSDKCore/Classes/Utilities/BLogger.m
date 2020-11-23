//
//  BLogger.m
//  ChatSDK
//
//  Created by ben3 on 29/09/2020.
//

#import "BLogger.h"

@implementation BLogger {
    dispatch_queue_main_t _queue;
}

@synthesize log = _log;
@synthesize publicLog = _publicLog;
@synthesize publicTranscript = _publicTranscript;

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

    va_list args;
    va_start(args, format);
    NSString * val = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    __weak __typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        __typeof(self) strongSelf = weakSelf;

    //    dispatch_async(dispatch_get_main_queue(), ^{
            if (!strongSelf.log) {
                strongSelf.log = @"\n===\nLog\n===\n\n\n";
            }
            strongSelf.log = [strongSelf.log stringByAppendingFormat:@"%@ %@ \n\n", [NSDate date], val];
            NSLog(@"%@", val);
    //    });
    });

}

-(void)publicLog: (NSString *)format, ... {

    va_list args;
    va_start(args, format);
    NSString * val = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    __weak __typeof(self) weakSelf = self;
    dispatch_async(_queue, ^{
        __typeof(self) strongSelf = weakSelf;
        if (!strongSelf.publicTranscript) {
            strongSelf.publicTranscript = [NSMutableArray new];
        }
        if (!strongSelf.publicLog) {
            strongSelf.publicLog = @"\n===\nPub\n===\n\n\n";
        }

        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"HH:mm:ss";

        [strongSelf.publicTranscript addObject:[NSString stringWithFormat:@"%@ %@ \n\n", [formatter stringFromDate:NSDate.date], val]];
        strongSelf.publicLog = [strongSelf.publicLog stringByAppendingFormat:@"%@ %@ \n\n", [formatter stringFromDate:NSDate.date], val];
    });

}

@end
