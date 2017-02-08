//
//  BMessageSection.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 27/12/2016.
//
//

#import <Foundation/Foundation.h>

@protocol PElmMessage;

@interface BMessageSection : NSObject {
    NSMutableArray * _messages;
    UIView * _view;
}

-(id) initWithMessages: (NSArray *) messages;
-(NSString *) title;
-(id<PElmMessage>) messageForRow: (int) row;
-(int) rowCount;
-(void) addMessage: (id<PElmMessage>) message;
-(UIView *) view;

@end
