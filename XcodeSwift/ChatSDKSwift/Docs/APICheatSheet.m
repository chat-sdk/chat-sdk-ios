//
//  APICheatSheet.m
//  ChatSDKSwift
//
//  Created by ben3 on 07/01/2021.
//  Copyright © 2021 deluge. All rights reserved.
//

#import "APICheatSheet.h"
#import "ChatSDK/Core.h"
//#import "ChatSDKSwift/ChatSDKSwift-Swift.h"
#import <ChatSDKSwift-Swift.h>

@implementation APICheatSheet

-(void) configuration {
    BConfiguration * config = BChatSDK.config;
    
    // Example
    config.googleMapsApiKey = @"Google Maps API Key";
}

-(void) messagingServerAPI {
    id<PNetworkAdapter> networkAdapter = BChatSDK.shared.networkAdapter;
    
    // Core Methods
    id<PCoreHandler> core = networkAdapter.core;
    id<PAuthenticationHandler> auth = networkAdapter.auth;
    id<PThreadHandler> thread = networkAdapter.thread;
    id<PImageMessageHandler> imageMessage = networkAdapter.imageMessage;
    id<PLocationMessageHandler> locationMessage = networkAdapter.locationMessage;
    id<PContactHandler> contact = networkAdapter.contact;
    id<PSearchHandler> search = networkAdapter.search;
    id<PPublicThreadHandler> publicThread = networkAdapter.publicThread;

    // Free modules
    id<PPushHandler> push = networkAdapter.push;
    id<PUploadHandler> upload = networkAdapter.upload;

    // Paid modules
    id<PVideoMessageHandler> videoMessage = networkAdapter.videoMessage;
    id<PAudioMessageHandler> audioMessage = networkAdapter.audioMessage;
    id<PTypingIndicatorHandler> typingIndicator = networkAdapter.typingIndicator;
    id<PLastOnlineHandler> lastOnline = networkAdapter.lastOnline;
    id<PBlockingHandler> blocking = networkAdapter.blocking;
    id<PNearbyUsersHandler> nearbyUsers = networkAdapter.nearbyUsers;
    id<PReadReceiptHandler> readReceipt = networkAdapter.readReceipt;
    id<PStickerMessageHandler> stickerMessage = networkAdapter.stickerMessage;
    id<PFileMessageHandler> fileMessage = networkAdapter.fileMessage;
    id<PEncryptionHandler> encryption = networkAdapter.encryption;
    
    // Push the user's profile data to the server
    [BChatSDK.core pushUser].thenOnMain(^id(id success) {

        return nil;
    }, ^id(NSError * error) {
        
        return nil;
    });
    
    // Get the current user
    id<PUser> user = BChatSDK.currentUser;
    
    // Get a user and update their proifle from the server
    id<PUser> otherUser = [BChatSDK.core userForEntityID:@"User Entity ID"];
    
    // Login
    [BChatSDK.auth authenticate:[BAccountDetails username:@"username" password:@"password"]].thenOnMain(^id(id success) {
        
        return nil;
    }, ^id(NSError * error) {
        
        return nil;
    });

    // Check if user is logged in
    bool isLoggedIn = BChatSDK.auth.isAuthenticated;

    // Log out
    [BChatSDK.auth logout];
    
    // Create thread
    [BChatSDK.thread createThreadWithUsers:@[otherUser] name:@"Name" threadCreated:^(NSError * error, id<PThread> thread) {
        
        // Send a message
        [BChatSDK.thread sendMessageWithText:@"Hi" withThreadEntityID:thread.entityID];
        
    }];

    // Get a list of public threads
    NSArray * threads = [BChatSDK.thread threadsWithType:bThreadType1to1];
}

-(void) messagingServerNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserverForName:bNotificationLogout object:Nil queue:Nil usingBlock:^(NSNotification * notification) {

    }];

    [BChatSDK.hook addHook:[BHook hookOnMain:^(NSDictionary * dict) {
        id<PMessage> message = dict[bHook_PMessage];
        if (message) {
            NSLog(@"%@", message.text);
        }
    } weight:10] withNames:@[bHookMessageRecieved, bHookMessageWillSend]];
        
}

-(void) uiService {
    
    id<PInterfaceAdapter> interfaceAdapter = BChatSDK.ui;
    
//    // Override the chat view controller
//    [BChatSDK.ui setChatViewController: ^UIViewController *(id<PThread> thread) {
//        return [[AChatViewController alloc] initWithThread:thread];
//    }];
//
//    // Override the private threads tab
//    [BChatSDK.ui setPrivateThreadsViewController:[[APrivateThreadsViewController alloc] initWithNibName:nil bundle:nil]];
}

-(void) localDatabase {
    
    id<PStorageAdapter> storageAdapter = BChatSDK.db;
    
    // Create entity
    id<PUser> user = [BChatSDK.db createEntity:bUserEntity];

    // Fetch an entity with a given ID
    id<PThread> thread = [BChatSDK.db fetchEntityWithID:@"threadEntityID" withType:bThreadEntity];

    // Fetch or create an entity with a given ID
    id<PUser> otherUser = [BChatSDK.db fetchOrCreateEntityWithID:@"userEntityID" withType:bUserEntity];
    
    [user setName:@"Test"];
    [user setImageURL:@"http://something.png"];
    
    NSArray * users = thread.users;
    NSArray * messages = thread.messagesOrderedByDateNewestFirst;
    
    // etc...
}

@end
