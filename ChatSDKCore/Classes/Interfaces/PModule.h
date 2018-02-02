//
//  PModule.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/04/2017.
//
//

#ifndef PModule_h
#define PModule_h

#define bServerFirebase @"bServerFirebase"
#define bServerXMPP @"bServerXMPP"

@protocol PModule <NSObject>

-(void) activate;

@optional

-(void) activateWithServer: (NSString *) server;

@end

#endif /* PModule_h */
