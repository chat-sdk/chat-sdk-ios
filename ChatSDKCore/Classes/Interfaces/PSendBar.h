//
//  PChatViewSendBar.h
//  Pods
//
//  Created by Ben on 12/8/17.
//

#ifndef PSendBar_h
#define PSendBar_h

@protocol PSendBarDelegate;

typedef void(^Send)(void);

@protocol PSendBar <NSObject>

-(void) setAudioEnabled:(BOOL)enabled;
-(void) setSendBarDelegate: (id<PSendBarDelegate>) delegate;
-(BOOL) resignTextViewFirstResponder;
-(void) becomeTextViewFirstResponder;
-(void) setMaxLines: (NSInteger) maxLines;
-(void) setMaxCharacters: (NSInteger) maxCharacters;
-(void) setText: (NSString *) text;
-(NSString *) text;
-(void) setReadOnly: (BOOL) readonly;

-(void) setSendListener: (Send) listener;

@end

#endif /* PChatViewSendBar_h */
