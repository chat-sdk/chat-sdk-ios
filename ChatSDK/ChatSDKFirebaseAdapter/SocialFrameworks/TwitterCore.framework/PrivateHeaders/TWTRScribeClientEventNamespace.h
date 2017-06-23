//
//  TWTRScribeClientEventNamespace.h
//  TwitterKit
//
//  Created by Kang Chen on 11/14/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWTRScribeSerializable.h"

FOUNDATION_EXPORT NSString *const TWTRScribeClientEventNamespaceEmptyValue;

/**
 *  Model object for describing any client events at Twitter.
 *  @see https://confluence.twitter.biz/display/ANALYTICS/client_event+Namespacing
 */
@interface TWTRScribeClientEventNamespace : NSObject <TWTRScribeSerializable>

/**
 *  The client application logging the event.
 */
@property (nonatomic, copy, readonly) NSString *client;

/**
 *  The page or functional grouping where the event occurred
 */
@property (nonatomic, copy, readonly) NSString *page;

/**
 *  A stream or tab on a page.
 */
@property (nonatomic, copy, readonly) NSString *section;

/**
 *  The actual page component, object, or objects where the event occurred.
 */
@property (nonatomic, copy, readonly) NSString *component;

/**
 *  A UI element within the component that can be interacted with.
 */
@property (nonatomic, copy, readonly) NSString *element;

/**
 *  The action the user or application took.
 */
@property (nonatomic, copy, readonly) NSString *action;

- (instancetype)init __unavailable;
- (instancetype)initWithClient:(NSString *)client page:(NSString *)page section:(NSString *)section component:(NSString *)component element:(NSString *)element action:(NSString *)action __attribute__((nonnull));

#pragma mark - Errors

/**
 *  Describes generic errors encounted inside Twitter Kits.
 */
+ (instancetype)errorNamespace;

@end
