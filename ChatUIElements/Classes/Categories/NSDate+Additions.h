//
//  NSDate+Additions.h
//  Chat SDK
//
//  Created by Simon Smiley-Andrews on 03/03/2015.
//  Copyright (c) 2015 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//


@interface NSDate (Additions)

-(NSString *) threadTimeAgo;
-(NSString *) messageTimeAt;
-(NSString *) lastSeenTimeAgo;
-(NSString *) dateAgo;

@end

