//
//  PElmUser.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 01/02/2017.
//
//

#ifndef PElmUser_h
#define PElmUser_h

@class RXPromise;

@protocol PElmUser <NSObject>

-(NSString *) entityID;
-(NSString *) name;

-(UIImage *) defaultImage;
-(NSString *) imageURL;
-(UIImage *) imageAsImage;
-(BOOL) isMe;

@end

#endif /* PElmUser_h */
