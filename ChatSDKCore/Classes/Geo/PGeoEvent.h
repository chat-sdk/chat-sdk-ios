//
//  PGeoEvent.h
//  Pods
//
//  Created by Benjamin Smiley-Andrews on 10/04/2019.
//

#ifndef PGeoEvent_h
#define PGeoEvent_h

#import <ChatSDK/PGeoItem.h>
#import <ChatSDK/BGeoEventType.h>

@protocol PGeoEvent <NSObject>

-(bGeoEventType) type;
-(id<PGeoItem>) item;

@end

#endif /* PGeoEvent_h */
