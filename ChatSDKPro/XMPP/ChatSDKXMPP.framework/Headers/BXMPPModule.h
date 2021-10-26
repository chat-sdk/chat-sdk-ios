//
//  BXMPPModule.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/07/2017.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDK/PModule.h>
//#import <ChatSDK/ChatSDK-Swift.h>
#import <ChatSDK/PInterfaceAdapterProvider.h>
#import <ChatSDK/PNetworkAdapterProvider.h>


@class BXMPPNetworkAdapter;
@class BXMPPInterfaceAdapter;

@interface BXMPPModule : NSObject<PModule, PInterfaceAdapterProvider, PNetworkAdapterProvider> {
    BXMPPNetworkAdapter * _networkAdapter;
    BXMPPInterfaceAdapter * _interfaceAdapter;
}

@end
