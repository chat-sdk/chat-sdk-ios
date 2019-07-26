//
//  BGoogleUtils.h
//  AFNetworking
//
//  Created by ben3 on 20/05/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGoogleUtils : NSObject

+(NSString *) getMapImageURL: (double) latitude longitude: (double) longitude width: (int) width height: (int) height;
+(NSString *) getMapImageWebLink: (double) latitude longitude: (double) longitude;
@end

NS_ASSUME_NONNULL_END
