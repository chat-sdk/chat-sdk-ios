//
//  BMessageSection.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 27/12/2016.
//
//

#import <Foundation/Foundation.h>

@protocol PElmMessage;
@protocol PMessageLayout;

@interface BMessageSection : NSObject {
    NSMutableArray * _messages;
    UIView * _view;
}

-(instancetype) initWithMessages: (NSArray *) messages;
-(NSString *) title;
-(id<PElmMessage, PMessageLayout>) messageForRow: (NSInteger) row;
-(NSInteger) rowCount;
-(void) addMessage: (id<PElmMessage>) message;
-(UIView *) view;

@end
