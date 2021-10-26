//
//  XMPPvCardTempTel.h
//  XEP-0054 vCard-temp
//
//  Created by Eric Chamberlain on 3/9/11.
//  Copyright 2011 RF.com. All rights reserved.
//  Copyright 2010 Martin Morrison. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "XMPPvCardTempBase.h"

NS_ASSUME_NONNULL_BEGIN
@interface XMPPvCardTempTel : XMPPvCardTempBase


+ (XMPPvCardTempTel *)vCardTelFromElement:(NSXMLElement *)elem;

@property (nonatomic, assign)   BOOL isCell;
@property (nonatomic, assign)   BOOL isVideo;
@property (nonatomic, assign)   BOOL isBBS;
@property (nonatomic, assign)   BOOL isModem;
@property (nonatomic, assign)   BOOL isISDN;
@property (nonatomic, assign)   BOOL isPCS;
@property (nonatomic, assign)   BOOL isPreferred;

- (BOOL)isHome;
- (void)setIsHome:(BOOL)home;

- (BOOL)isWork;
- (void)setIsWork:(BOOL)work;

- (BOOL)isVoice;
- (void)setIsVoice:(BOOL)voice;

- (BOOL)isFax;
- (void)setIsFax:(BOOL)fax;

- (BOOL)isPager;
- (void)setIsPager:(BOOL)pager;

- (BOOL)hasMessaging;
- (void)setIsMessaging:(BOOL)msg;

- (NSString *)number;
- (void)setNumber:(NSString *)number;

@end
NS_ASSUME_NONNULL_END
