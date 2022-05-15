//
//  BGeoItem.h
//  AFNetworking
//
//  Created by Benjamin Smiley-Andrews on 08/04/2019.
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PGeoItem.h>

NS_ASSUME_NONNULL_BEGIN

#define bGeoItemTypeUser @"user"
#define bGeoItemTypeThread @"thread"

@class CLLocation;

@interface BGeoItem : NSObject<PGeoItem>

@property (nonatomic, readwrite) NSString * entityID;
@property (nonatomic, readwrite) NSString * type;
@property (nonatomic, readwrite) CLLocation * location;

+(instancetype) item: (NSString *) itemID;
+(instancetype) item: (NSString *) entityID withType: (NSString *) type;
-(instancetype) init: (NSString *) entityID withType: (NSString *) type;
-(instancetype) init: (NSString *) itemID;

-(NSString *) itemID;
-(BOOL) typeIs: (NSString *) type;

@end

NS_ASSUME_NONNULL_END
