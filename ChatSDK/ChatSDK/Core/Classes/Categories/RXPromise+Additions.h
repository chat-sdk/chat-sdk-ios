//
//  RXPromise+Additions.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 29/07/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RXPromise/RXPromise.h>

@interface RXPromise(Additions)

+(RXPromise *) rejectWithReasonDomain: (NSString *) domain code: (int) code description: (NSString *) description;
+(RXPromise *) rejectWithReason: (NSError *) error;
+(RXPromise *) resolveWithResult: (id) result;

@end
