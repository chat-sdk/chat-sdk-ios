//
//  TFSScribe.h
//  TFSScribe
//
//  Created by Tanner Oakes on 10/10/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef NS_DESIGNATED_INITIALIZER
#define NS_DESIGNATED_INITIALIZER __attribute((objc_designated_initializer))
#endif

FOUNDATION_EXTERN NSString *const TFSScribeDebugPreferencesKey;

FOUNDATION_EXTERN NSString *const TFSScribeEventNotification;  // Triggered when the scribe API call returns
FOUNDATION_EXTERN NSString *const TFSScribeFlushNotification;  // Triggered after scribe flush
FOUNDATION_EXTERN NSString *const TFSScribeFlushTokenInfoKey;  // Key in userInfo dictionary corresponding to the token used in the flush request.

FOUNDATION_EXTERN const NSInteger TFSScribeServiceUpdateValue;

/**
 *  Result of handling outgoing scribe events.
 */
typedef NS_ENUM(NSUInteger, TFSScribeServiceRequestDisposition) {
    /**
     *  Indicates that the outgoing events were handled successfully.
     */
    TFSScribeServiceRequestDispositionSuccess,
    /**
     *  Indicates that handling failed due to a client side problem, such as a network
     *  timeout or the request being cancelled.
     */
    TFSScribeServiceRequestDispositionClientError,
    /**
     *  Indicates that handling failed due to the server rejecting the sent data.
     */
    TFSScribeServiceRequestDispositionServerError,
};

/**
 *  Object representing a scribe event. These methods must be thread safe.
 */
@protocol TFSScribeEventParameters <NSObject>

/**
 *  Binary representation of the scribe event. This is what will be kept in
 *  the store and returned when flush is called.
 */
- (NSData *)data;
/**
 *  Dictionary representation of the event used for logging purposes.
 */
- (NSDictionary *)dictionaryRepresentation;
/**
 *  User ID of event
 */
- (NSString *)userID;

@end

@class TFSScribe;

@protocol TFSScribeErrorDelegate <NSObject>

/**
 *  Scribe will call this method on an arbitrary queue if it encounters
 *  an internal error.
 */
- (void)scribeService:(TFSScribe *)service didEncounterError:(NSError *)error;

@end

typedef void (^TFSScribeRequestBatchedImpressionEventBlock)(id<TFSScribeEventParameters> scribeEventParameters);
typedef void (^TFSScribeRequestCompletionBlock)(TFSScribeServiceRequestDisposition disposition);

@protocol TFSScribeRequestHandler <NSObject>

/**
 *  TFSScribe will call this method once it has prepared all of the outgoing events.
 *  This method will be called on a background queue.
 *
 *  @param outgoingEvents    Prepared outgoing events
 *  @param userID            User ID to send events for. Must not be nil.
 *  @param completionHandler Execute the completion block once the events have been handled with the appropriate disposition. The completion block can be executed on any queue.
 */
- (void)handleScribeOutgoingEvents:(NSString *)outgoingEvents userID:(NSString *)userID completionHandler:(TFSScribeRequestCompletionBlock)completionHandler;

@optional

/**
 *  When flushing a user ID, this method will be called with an array of impressions
 *  for you to batch. After the method is executed, the impressions will be deleted
 *  from the store. If this method is not implemented, impressions will still be
 *  deleted.
 *
 *  @param impressions Array of TFSScribeImpressions objects.
 *  @param batchedHandler Call the batchedHandler block for each event data you generate from the impressions.
 */
- (void)handleImpressionsBatch:(NSArray *)impressions batchedImpressionHandler:(TFSScribeRequestBatchedImpressionEventBlock)batchedHandler;

@end

@interface TFSScribe : NSObject

@property (nonatomic, weak) id<TFSScribeErrorDelegate> errorDelegate;

+ (BOOL)isDebugEnabled;
+ (void)setDebugEnabled:(BOOL)enabled;

/**
 *  Init the scribe.
 *
 *  @param storeURL File URL to store the persisted data. Pass nil to use an in-memory store.
 */
- (instancetype)initWithStoreURL:(NSURL *)storeURL;

/**
 *  Init the scribe.
 *
 *  @param storeURL File URL to store the persisted data. Pass nil to use an in-memory store.
 *  @param modelURL File URL to the location of the mom on disk. Not necessary if you are using the framework, or if your mom is in the mainBundle.
 */
- (instancetype)initWithStoreURL:(NSURL *)storeURL modelURL:(NSURL *)modelURL NS_DESIGNATED_INITIALIZER;

/**
 *  Opens the scribe asynchronously.
 */
- (void)open;

/**
 *  Opens the scribe asynchronously.
 *
 *  @param startBlock      Block will be executed on a background queue immediately prior to opening. Can be nil.
 *  @param completionBlock Block will be executed on a background queue immediately after opening. Can be nil.
 */
- (void)openWithStartBlock:(dispatch_block_t)startBlock completionBlock:(dispatch_block_t)completionBlock;

/**
 *  Closes the scribe asynchronously.
 */
- (void)close;

/**
 *  Closes the scribe asynchronously.
 *
 *  @param startBlock      Block will be executed on a background queue immediately prior to closing. Can be nil.
 *  @param completionBlock Block will be executed on a background queue immediately after closing. Can be nil.
 */
- (void)closeWithStartBlock:(dispatch_block_t)startBlock completionBlock:(dispatch_block_t)completionBlock;

/**
 *  Suspend the scribe's internal background queue. This could be used to improve scrolling performance on older devices.
 */
- (void)suspend;
/**
 *  Resume the scribe's internal background queue.
 */
- (void)resume;

/**
 *  Flush all events for the given userID. If no events or impressions exist
 *
 *  @param userID         User ID to flush events for. Must not be nil.
 *  @param requestHandler Once the events have been prepared, the request handler will be called to handle the events. Must not be nil.
 */
- (void)flushUserID:(NSString *)userID requestHandler:(id<TFSScribeRequestHandler>)requestHandler;

/**
 *  Flush all events for the given userID.
 *
 *  @param userID         User ID to flush events for. Must not be nil.
 *  @param token          A token to be included with notification userInfo dictionaries.
 *  @param requestHandler Once the events have been prepared, the request handler will be called to handle the events. Must not be nil.
 */
- (void)flushUserID:(NSString *)userID token:(NSString *)token requestHandler:(id<TFSScribeRequestHandler>)requestHandler;

/**
 *  Delete all events for the given userID. Events for user ID of 0 (anonymous user) will not be deleted.
 */
- (void)deleteUserID:(NSString *)userID;

/**
 *  Schedule an event to be added to scribe.
 */
- (void)enqueueEvent:(id<TFSScribeEventParameters>)eventParameters;

/**
 *  Schedule an impression to be added to scribe.
 */
- (void)enqueueImpression:(NSData *)contentData eventName:(NSString *)eventName query:(NSString *)query clientVersion:(NSString *)clientVersion userID:(NSString *)userID;

#if UIAUTOMATION
- (void)clearScribeDatabase;
#endif

@end
