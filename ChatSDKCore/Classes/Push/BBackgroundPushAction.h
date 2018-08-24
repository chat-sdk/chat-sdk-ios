//
//  BBackgroundPushAction.h
//  AFNetworking
//
//  Created by Ben on 8/24/18.
//

#import <Foundation/Foundation.h>

#define bPushThreadEntityID @"chat_sdk_thread_entity_id"
#define bPushUserEntityID @"chat_sdk_user_entity_id"

typedef enum {
    bPushActionTypeOpenThread
} bPushActionType;

@interface BBackgroundPushAction : NSObject

@property (nonatomic, readwrite) bPushActionType type;
@property (nonatomic, readwrite) NSDictionary * payload;

+(instancetype) actionWithType: (bPushActionType) type payload: (NSDictionary *) payload;

@end
