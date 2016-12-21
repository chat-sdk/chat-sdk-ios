//
//  TWTRAPIClient.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

@class TWTRUser;
@class TWTRTweet;
@class TWTRAuthConfig;
@class TWTRGuestSession;
@protocol TWTRAuthSession;
@protocol TWTRSessionStore;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const TWTRTweetsNotLoadedKey;

/**
 *  @name Completion Block Types
 */

/**
 *  Completion block called when the load user request succeeds or fails.
 *
 *  @param user  The Twitter User.
 *  @param error Error that will be set if the API request failed.
 */
typedef void (^TWTRLoadUserCompletion)(TWTRUser * __twtr_nullable user, NSError * __twtr_nullable error);

/**
 *  Completion block called when the load Tweet request succeeds or fails.
 *
 *  @param tweet The Twitter Tweet.
 *  @param error Error that will be set if the API request failed.
 */
typedef void (^TWTRLoadTweetCompletion)(TWTRTweet * __twtr_nullable tweet, NSError * __twtr_nullable error);

/**
 *  Completion block called when the load Tweets request succeeds or fails.
 *
 *  @param tweets Tweets that were successfully retrieved.
 *  @param error  Error that will be set if the API request failed.
 */
typedef void (^TWTRLoadTweetsCompletion)(NSArray * __twtr_nullable tweets, NSError * __twtr_nullable error);

/**
 *  Completion block called when the network request succeeds or fails.
 *
 *  @param response        Metadata associated with the response to a URL load request.
 *  @param data            Content data of the response.
 *  @param connectionError Error object describing the network error that occurred.
 */
typedef void (^TWTRNetworkCompletion)(NSURLResponse * __twtr_nullable response, NSData * __twtr_nullable data, NSError * __twtr_nullable connectionError);

/**
 *  Completion block called when a JSON request to the Twitter API succeeds or fails.
 *
 *  @param response       Metadata associated with the response to a URL load request.
 *  @param responseObject Content data of the response.
 *  @param error          Error object describing the network error that occurred.
 */
typedef void (^TWTRJSONRequestCompletion)(NSURLResponse * __twtr_nullable response, id __twtr_nullable responseObject, NSError * __twtr_nullable error);

/**
 *  Completion block called when a Tweet action (favorite/retweet) is performed.
 *
 *  @param response Metadata associated with the response to a URL load request.
 *  @param tweet    The Tweet object representing the new state of this Tweet from
 *                  the perspective of the currently-logged in user.
 *  @param error    Error object describing the error that occurred. This will be either a 
 *                  network error or an NSError with an errorCode corresponding to 
 *                  TWTRAPIErrorCodeAlreadyFavorited or TWTRAPIErrorCodeAlreadyRetweeted
 *                  for an attempted action that has already been taken from the servers
 *                  point of view for this logged-in user.
 */
typedef void (^TWTRTweetActionCompletion)(TWTRTweet * __twtr_nullable tweet, NSError * __twtr_nullable error);

/**
 *  Client for consuming the Twitter REST API. Provides methods for common API requests, as well as the ability to create and send custom requests.
 */
@interface TWTRAPIClient : NSObject

/**
 *  The Twitter user ID this client is making API requests on behalf of or
 *  nil if it is a guest user.
 */
@property (nonatomic, copy, readonly, twtr_nullable) NSString *userID;


/**
 *  Constructs a `TWTRAPIClient` object to perform authenticated API requests with user authentication.
 *
 *  @param userID (optional) ID of the user to make requests on behalf of. If the ID is nil requests will be made using guest authentication.
 *
 *  @return Fully initialized API client to make authenticated requests against the Twitter REST API.
 */
- (instancetype)initWithUserID:(twtr_nullable NSString *)userID;

/**
 *  @name Making Requests
 */

/**
 *  Returns a signed URL request.
 *
 *  @param method     Request method, GET, POST, PUT, DELETE, etc.
 *  @param URL        Request URL. This is the full Twitter API URL. E.g. https://api.twitter.com/1.1/statuses/user_timeline.json
 *  @param parameters Request parameters.
 *  @param error      Error that will be set if there was an error signing the request.
 *
 *  @note If the request is not sent with the -[TWTRAPIClient sendTwitterRequest:completion:] method it is the developers responsibility to ensure that there is a valid guest session before this method is called.
 */
- (NSURLRequest *)URLRequestWithMethod:(NSString *)method URL:(NSString *)URLString parameters:(twtr_nullable NSDictionary *)parameters error:(NSError **)error;

/**
 *  Sends a Twitter request.
 *
 *  @param request    The request that will be sent asynchronously.
 *  @param completion Completion block to be called on response. Called on main queue.
 */
- (void)sendTwitterRequest:(NSURLRequest *)request completion:(TWTRNetworkCompletion)completion;

/**
 *  @name Common API Actions
 */

/**
 *  Loads a Twitter User.
 *
 *  @param userID       (required) The Twitter user ID of the desired user.
 *  @param completion   Completion block to be called on response. Called on main queue.
 */
- (void)loadUserWithID:(NSString *)userID completion:(TWTRLoadUserCompletion)completion;

/**
 *  Loads a single Tweet from the network or cache.
 *
 *  @param tweetID      (required) The ID of the desired Tweet.
 *  @param completion   Completion bock to be called on response. Called on main queue.
 */
- (void)loadTweetWithID:(NSString *)tweetID completion:(TWTRLoadTweetCompletion)completion;

/**
 *  Loads a series of Tweets in a batch. The completion block will be passed an array of zero or more
 *  Tweets that loaded successfully. If some Tweets fail to load the array will contain less Tweets than
 *  number of requested IDs. If any Tweets fail to load, the IDs of the Tweets that did not load will
 *  be provided in the userInfo dictionary property of the error parameter under `TWTRTweetsNotLoadedKey`.
 *
 *  @param tweetIDStrings (required) An array of Tweet IDs.
 *  @param completion     Completion block to be called on response. Called on main queue.
 */
- (void)loadTweetsWithIDs:(NSArray *)tweetIDStrings completion:(TWTRLoadTweetsCompletion)completion;

@end

NS_ASSUME_NONNULL_END
