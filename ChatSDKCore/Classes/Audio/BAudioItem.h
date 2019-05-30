//
//  BAudioItem.h
//  AFNetworking
//
//  Created by ben3 on 15/05/2019.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BAudioItem : NSObject

@property (nonatomic, readwrite) AVPlayerItem * item;
@property (nonatomic, readwrite) double seekPosition;
@property (nonatomic, readwrite) NSURL * url;

@end

NS_ASSUME_NONNULL_END
