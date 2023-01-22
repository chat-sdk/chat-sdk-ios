//
//  BContactBookModule.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/04/2017.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PModule.h>

@class BLocationUpdater;

@interface BNearbyUsersModule : NSObject<PModule> {
    BLocationUpdater * _locationUpdater;
}

@property (nonatomic, readwrite) BOOL disabled;

+(nonnull BNearbyUsersModule *) shared;

-(void) startService;
-(void) stopService;

@end
