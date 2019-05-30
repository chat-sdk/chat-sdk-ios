//
//  BMessageSection.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 27/12/2016.
//
//

#import <Foundation/Foundation.h>

@protocol PMessage;

@interface BMessageSection : NSObject {
    NSMutableArray * _messages;
    UIView * _view;
    NSString * _dateText;
}

//-(instancetype) initWithMessages: (NSArray *) messages;
-(instancetype) initWithDateText: (NSString *) dateText;
-(NSString *) title;
-(id<PMessage>) messageForRow: (NSInteger) row;
-(NSInteger) rowCount;

-(NSInteger) addMessage: (id<PMessage>) message;
-(NSInteger) removeMessage: (id<PMessage>) message;

-(UIView *) view;
-(NSString *) dateText;

-(int) rowForMessage: (id<PMessage>) message;

-(id<PMessage>) newestMessage;
-(id<PMessage>) oldestMessage;

-(void) debug;

@end
