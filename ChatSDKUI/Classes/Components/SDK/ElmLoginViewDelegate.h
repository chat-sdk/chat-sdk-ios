//
//  ElmLoginViewDelegate.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 07/02/2017.
//
//

#ifndef ElmLoginViewDelegate_h
#define ElmLoginViewDelegate_h

@class RXPromise;

@protocol ElmLoginViewDelegate <NSObject>

-(RXPromise *) loginWithUsername: (NSString *) username password: (NSString *) password;
-(RXPromise *) registerWithUsername: (NSString *) username password: (NSString *) password;
-(RXPromise *) facebook;
-(RXPromise *) twitter;
-(RXPromise *) googlePlus;
-(RXPromise *) anonymous;
-(RXPromise *) resetPasswordWithCredential: (NSString *) credential;
-(NSString *) usernamePlaceholder;

@end

#endif /* ElmLoginViewDelegate_h */
