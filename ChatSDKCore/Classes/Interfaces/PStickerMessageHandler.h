//
//  PStickersHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 16/12/2016.
//
//

#ifndef PStickersHandler_h
#define PStickersHandler_h

@class RXPromise;

@protocol PStickerMessageHandler <NSObject>

-(RXPromise *) sendMessageWithSticker: (NSString *) stickerName withThreadEntityID: (NSString *) threadID;
-(Class) cellClass;

-(NSString *) stickerPlistName;
-(NSBundle *) stickerBundle;
-(void) setStickerPlistName: (NSString *) name withBundle: (NSBundle *) bundle;

@end

#endif /* PStickersHandler_h */
