//
//  PLogger.h
//  Pods
//
//  Created by ben3 on 29/09/2020.
//

#ifndef PLogger_h
#define PLogger_h

@protocol PLogger
    
//-(void) log: (NSString *) text;
-(void) log:(NSString *)format, ...;
-(void) publicLog: (NSString *)format, ...;
-(void)remoteLog: (NSString *) message;

-(NSString *) log;
-(NSString *) publicLog;
-(NSMutableArray<NSString *> *) publicTranscript;

@end

#endif /* PLogger_h */
