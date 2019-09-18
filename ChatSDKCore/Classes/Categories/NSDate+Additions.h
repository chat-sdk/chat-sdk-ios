//
//  NSDate+Additions.h
//  Chat SDK
//
//  Created by Simon Smiley-Andrews on 03/03/2015.
//  Copyright (c) 2015 deluge. All rights reserved.
//


@interface NSDate (Additions)

-(NSString *) threadTimeAgo;
-(NSString *) messageTimeAt;
-(NSString *) lastSeenTimeAgo;
-(NSString *) dateAgo;

-(BOOL) isNextDay: (NSDate *) date;
-(BOOL) isPreviousDay: (NSDate *) date;

@end

