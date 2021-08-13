//
//  BXMPPServerCache.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 30/08/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BXMPPServerCache : NSObject {
    NSMutableDictionary * _values;
}

+(BXMPPServerCache *) sharedCache;
-(void) invalidate;

-(void) setAvailableSearchIndexes: (NSArray *) searchIndexes;
-(NSArray *) availableSearchIndexes;

@end
