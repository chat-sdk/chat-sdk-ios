//
//  PMessageHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 16/12/2016.
//
//

#ifndef PMessageHandler_h
#define PMessageHandler_h

@protocol PMessage;

@protocol PMessageHandler <NSObject>

//-(NSDictionary *) serialize: (id<PMessage>) message;
//-(void) deserialize: (id<PMessage>) message withData: (NSDictionary *) data;

// This is really needed for modules which provide a custom message cell class
@optional
-(Class) cellClass;

@end

#endif /* PMessageHandler_h */
