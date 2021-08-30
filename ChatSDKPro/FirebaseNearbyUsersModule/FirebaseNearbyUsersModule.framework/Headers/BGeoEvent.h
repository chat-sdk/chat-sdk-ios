//
//  BGeoEvent.h
//  AFNetworking
//
//  Created by Benjamin Smiley-Andrews on 08/04/2019.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/BGeoEventType.h>

@class CLLocation;
@class BGeoItem;

NS_ASSUME_NONNULL_BEGIN

@interface BGeoEvent : NSObject

@property (nonatomic, readwrite) bGeoEventType type;
@property (nonatomic, readwrite) BGeoItem * item;

+(instancetype) event: (BGeoItem *) item withType: (bGeoEventType) type;
-(instancetype) init: (BGeoItem *) item withType: (bGeoEventType) type;

@end

NS_ASSUME_NONNULL_END
