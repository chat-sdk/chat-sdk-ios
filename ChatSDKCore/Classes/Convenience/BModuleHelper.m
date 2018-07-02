//
//  BModuleHelper.m
//  AFNetworking
//
//  Created by Ben on 2/1/18.
//

#import "BModuleHelper.h"
#import <ChatSDK/Core.h>

@implementation BModuleHelper

+(void) activateModules {
    [self activateCommonModules:[self currentServer]];
}

+(NSString *) currentServer {
    bool firebaseAdapter = NSClassFromString(@"BFirebaseNetworkAdapter") != Nil;
    bool xmppAdapter = NSClassFromString(@"BXMPPNetworkAdapter") != Nil;
    
    if(firebaseAdapter && xmppAdapter) {
        NSLog(@"You should only have one network adapter active in the project. The project will be setup to use the server type defined in configuration.defaultServer");
    }
    else {
        if(firebaseAdapter) {
            return bServerFirebase;
        }
        if(xmppAdapter) {
            return bServerXMPP;
        }
    }
    return [BChatSDK shared].configuration.defaultServer;
}

+(void) activateModulesForFirebase {
    [self activateCommonModules:bServerFirebase];
}

+(void) activateModulesForXMPP {
    [self activateCommonModules: bServerXMPP];
}

+(void) activateCommonModules: (NSString *) server {
    [self activateModuleForName:@"BBlockingModule"];
    [self activateModuleForName:@"BLastOnlineModule"];
    [self activateModuleForName:@"BAudioMessageModule"];
    [self activateModuleForName:@"BVideoMessageModule"];
    [self activateModuleForName:@"BNearbyUsersModule"];
    [self activateModuleForName:@"BReadReceiptsModule"];
    [self activateModuleForName:@"BTypingIndicatorModule"];
    [self activateModuleForName:@"BStickerMessageModule"];
    [self activateModuleForName:@"BDiagnosticModule"];
    [self activateModuleForName:@"BContactBookModule"];
    [self activateModuleForName:@"BKeyboardOverlayOptionsModule"];
}

+(void) activateCoreModules {
    NSString * server = [self currentServer];
    
    if([server isEqualToString:bServerFirebase]) {
        [self activateModuleForName:@"BFirebaseNetworkAdapterModule"];
        [self activateModuleForName:@"BDefaultUIModule"];
        [self activateModuleForName:@"BFirebaseSocialLoginModule"];
    }
    if([server isEqualToString:bServerXMPP]) {
        [self activateModuleForName:@"BXMPPModule"];
    }
    
    [self activateModuleForName:@"BCoreDataStorageModule"];
    
    [self activateModuleForName:@"BFirebaseFileStorageModule" server:server];
    [self activateModuleForName:@"BFirebasePushModule"];
}

+(void) activateModuleForName: (NSString *) name {
    [self activateModuleForName:name server:Nil];
}

+(void) activateModuleForName: (NSString *) name server: (NSString *) server {
    Class module = NSClassFromString(name);
    if (module) {
        id<PModule> instance = (id<PModule>) [[module alloc] init];
        if([instance respondsToSelector:@selector(activateWithServer:)] && server) {
            [instance activateWithServer: server];
        }
        else {
            [instance activate];
        }
        NSLog(@"%@ activated successfully", name);
    }
    else {
        NSLog(@"%@ wasn't available", name);
    }
}

@end
