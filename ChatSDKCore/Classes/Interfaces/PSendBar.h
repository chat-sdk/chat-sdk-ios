//
//  PChatViewSendBar.h
//  Pods
//
//  Created by Ben on 12/8/17.
//

#ifndef PSendBar_h
#define PSendBar_h

@protocol PSendBarDelegate;

@protocol PSendBar <NSObject>

-(void) setAudioEnabled:(BOOL)enabled;
-(void) setSendBarDelegate: (id<PSendBarDelegate>) delegate;
-(BOOL) resignTextViewFirstResponder;
-(void) becomeTextViewFirstResponder;
-(void) setMaxLines: (NSInteger) maxLines;
-(void) setMaxCharacters: (NSInteger) maxCharacters;

@end

#endif /* PChatViewSendBar_h */
