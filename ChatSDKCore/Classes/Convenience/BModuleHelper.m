//
//  BModuleHelper.m
//  AFNetworking
//
//  Created by Ben on 2/1/18.
//

#import "BModuleHelper.h"
#import <ChatSDK/Core.h>

@implementation BModuleHelper

-(instancetype) init {
    if((self = [super init])) {
    }
    return self;
}

-(void) activateUIModule {
    [self activateModuleForName:@"BDefaultUIModule"];
}

-(void) activateCoreModules {
    [self activateModuleForName:@"BCoreDataStorageModule"];
    [self activateModuleForName:@"BReachabilityModule"];
}

-(BOOL) activateModuleForName: (NSString *) name {
    return [self activateModuleForName:name server:Nil];
}

-(BOOL) activateModuleForName: (NSString *) name server: (NSString *) server {
    Class module = NSClassFromString(name);
    if (module) {
        id<PModule> instance = (id<PModule>) [[module alloc] init];
        if([instance respondsToSelector:@selector(activateWithServer:)] && server) {
            [instance activateWithServer: server];
        }
        else {
            [instance activate];
        }
        [BChatSDK.shared.logger log:@"%@ activated successfully", name];
        return YES;
    }
    else {
        [BChatSDK.shared.logger log:@"%@ wasn't available", name];
        return NO;
    }
}

@end
