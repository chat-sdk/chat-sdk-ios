//
//  XMPPService.h
//  AFNetworking
//
//  Created by Ben on 11/24/17.
//

#import <Foundation/Foundation.h>

@class XMPPJID;
@class XMPPIQ;

@interface BXMPPService : NSObject

@property (nonatomic, readwrite) XMPPJID * jid;
@property (nonatomic, readwrite) NSString * category;
@property (nonatomic, readwrite) NSString * type;
@property (nonatomic, readwrite) NSString * name;
@property (nonatomic, readwrite) NSMutableArray * features;

-(id) initWithIQ: (XMPPIQ *) iq;
-(BOOL) hasFeature: (NSString *) feature;

@end
