//
//  BUserMentionsAdapter.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 05/09/2017.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDKCore/ChatCore.h>
#import <Hakawai/HKWMentionsPlugin.h>

@interface BUserMentionsAdapter : NSObject <HKWMentionsEntityProtocol>

@property (nonatomic, weak) id<PUser> user;

- (NSString *)entityId;
- (NSString *)entityName;
- (NSDictionary *)entityMetadata;

- (id<PUser>)getUser;

- (id)initWithUser: (id<PUser>)user;

@end
