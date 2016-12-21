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

#define bStickerMessageCell @"bStickerMessageCell"

@protocol PStickerMessageHandler <NSObject>

-(RXPromise *) sendMessageWithSticker: (NSString *) stickerName withThreadEntityID: (NSString *) threadID;
-(Class) messageCellClass;

@end

#endif /* PStickersHandler_h */
