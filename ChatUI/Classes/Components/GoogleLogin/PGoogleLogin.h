//
//  PGoogleLogin.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 31/03/2017.
//
//

#ifndef PGoogleLogin_h
#define PGoogleLogin_h

@protocol PGoogleLogin <NSObject>

-(void) sendTextMessage: (NSString *) message;

// Return whether we should mark the button as selected
-(BOOL) showOptions;
// Return whether we should mark the button as deselected
-(BOOL) hideOptions;
-(void) sendAudioMessage: (NSData *) data duration:(double) seconds;
-(void) typing;

@end

#endif /* PGoogleLogin_h */
