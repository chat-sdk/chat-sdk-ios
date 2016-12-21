//
//  Twitter.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <TwitterCore/TWTRSession.h>
#import <TwitterKit/TWTRAPIClient.h>
#import <UIKit/UIKit.h>

@class TWTRSessionStore;

NS_ASSUME_NONNULL_BEGIN

/**
 * A notification which is posted when a user logs out of Twitter.
 * The notification will contain a user dictionary which contains
 * the user id which is being logged out. Note, this notification may
 * be posted as a result of starting the Twitter object.
 */
extern NSString * const TWTRUserDidLogOutNotification;
extern NSString * const TWTRLoggedOutUserIDKey;

/**
 *  The central class of the Twitter Kit.
 *  @note This class can only be used from the main thread.
 */
@interface Twitter : NSObject

/**
 *  Returns the Twitter singleton.
 *
 *  @return The Twitter singleton.
 */
+ (Twitter *)sharedInstance;

/**
 *  Start Twitter with your consumer key and secret. These will override any credentials
 *  present in your applications Info.plist.
 *
 *  You do not need to call this method unless you wish to provide credentials other than those
 *  in your Info.plist.
 *
 *  @param consumerKey    Your Twitter application's consumer key.
 *  @param consumerSecret Your Twitter application's consumer secret.
 */
- (void)startWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;

/**
 *  Start Twitter with a consumer key, secret, and keychain access group. See -[Twitter startWithConsumerKey:consumerSecret:]
 *
 *  @param consumerKey    Your Twitter application's consumer key.
 *  @param consumerSecret Your Twitter application's consumer secret.
 *  @param accessGroup    An optional keychain access group to apply to session objects stored in the keychain.
 *
 *  @note In the majority of situations applications will not need to specify an access group to use with Twitter sessions.
 *  This value is only needed if you plan to share credentials with another application that you control or if you are
 *  using TwitterKit with an app extension.
 */
- (void)startWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret accessGroup:(twtr_nullable NSString *)accessGroup;

/**
 *  The current version of this kit.
 */
@property (nonatomic, copy, readonly) NSString *version;

/**
 *  Authentication configuration details. Encapsulates the `consumerKey` and `consumerSecret` credentials required to authenticate a Twitter application.
 */
@property (nonatomic, strong, readonly) TWTRAuthConfig *authConfig;

/**
 *  Session store exposing methods to fetch and manage active sessions. Applications that need to manage
 *  multiple users should use the session store to authenticate and log out users.
 */
@property (nonatomic, strong, readonly) TWTRSessionStore *sessionStore;

/**
 *  Triggers user authentication with Twitter.
 *
 *  This method will present UI to allow the user to log in if there are no saved Twitter login credentials.
 *
 *  @param completion The completion block will be called after authentication is successful or if there is an error.
 *  @warning This method requires that you have set up your `consumerKey` and `consumerSecret`.
 */
- (void)logInWithCompletion:(TWTRLogInCompletion)completion;

/**
 *  Triggers user authentication with Twitter. Allows the developer to specify the presenting view controller.
 *
 *  This method will present UI to allow the user to log in if there are no saved Twitter login credentials.
 *
 *  @param viewController The view controller that will be used to present the authentication view.
 *  @param completion The completion block will be called after authentication is successful or if there is an error.
 *  @warning This method requires that you have set up your `consumerKey` and `consumerSecret`.
 */
- (void)logInWithViewController:(twtr_nullable UIViewController *)viewController completion:(TWTRLogInCompletion)completion;

@end

@interface Twitter (TWTRDeprecated)

/**
 *  The Twitter application consumer key.
 *  @deprecated This property is deprecated and will be removed in a later release. Please use `authConfig`.
 */
@property (nonatomic, copy, readonly) NSString *consumerKey __attribute__((deprecated("Use `authConfig`. This property will be removed in a later release.")));

/**
 *  The Twitter application consumer secret.
 *  @deprecated This property is deprecated and will be removed in a later release. Please use `authConfig`.
 */
@property (nonatomic, copy, readonly) NSString *consumerSecret __attribute__((deprecated("Use `authConfig`. This property will be removed in a later release.")));

/**
 *  Log in a guest user. This can be used when the user is not a Twitter user.
 *
 *  This method will not present any UI to the user.
 *
 *  @param completion The completion block will be called after authentication is successful or if there is an error.
 *  @warning This method requires that you have set up your `consumerKey` and `consumerSecret`.
 *  @warning This method will soon be deprecated; it is no longer needed. Users can use the -[Twitter guestAPIClient] directly without needing to call this method.
 */
- (void)logInGuestWithCompletion:(TWTRGuestLogInCompletion)completion;

/**
 *  Triggers user authentication with Twitter given an existing session.
 *
 *  Use this method if you have already authenticated with Twitter and are migrating to TwitterKit. This
 *  method will verify that the `authToken` and `authTokenSecret` are still valid and log the user in with
 *  the existing credentials.
 *
 *  @param authToken The existing authToken to use for authentication.
 *  @param authTokenSecret The existing authTokenSecret to use for authentication.
 *  @param completion The completion block will be called after authentication is successful or if there is an error.
 *  @warning This method requires that you have set up your `consumerKey` and `consumerSecret`.
 *  @warning This method will soon be deprecated; for a simpler approach see -[TWTRSessionStore saveSession:completion:].
 */
- (void)logInWithExistingAuthToken:(NSString *)authToken authTokenSecret:(NSString *)authTokenSecret completion:(TWTRLogInCompletion)completion;

/**
 *  Client for consuming the Twitter REST API.
 *
 *  This API client is configured with your consumer key and secret if they are available to the Twitter
 *  object (either via initialization of the Twitter instance or your application's Info.plist).
 *
 *  @warning To make authenticated requests, you need to call `loginWithCompletion:`
 *  @warning This method will soon be deprecated. Using this method does not
 *           give you control over which user you are making request on the behalf of. 
 *           It is recommended that users migrate to using -[TWTRAPIClient initWithUserID:] to have more explicit control.
 */
@property (nonatomic, strong, readonly) TWTRAPIClient *APIClient;

/**
 *  Returns the current user session or nil if there is no logged in user.
 *
 *  @return Returns the current user session or nil if there is no logged in user.
 *  @warning This method will soon be deprecated; it is recommended to use -[TWTRSessionStore session] or -[TWTRSessionStore sessionForUserID:] if they are managing multiple users
 */
- (twtr_nullable TWTRSession *)session;

/**
 *  Returns the current guest session or nil if there is no logged in guest.
 *
 *  @return Returns the current guest session or nil if there is no logged in guest.
 *  @warning This method will soon be deprecated; all network requests will fall back to using a guest session if no user session is provided.
 */
- (twtr_nullable TWTRGuestSession *)guestSession;

/**
 *  Deletes the local Twitter user session from this app. This will not remove the system Twitter account nor make a network request to invalidate the session.
 *  @warning This method will soon be deprecated; users are encouraged to call -[TWTRSessionStore logOutUserID:] instead of calling this method on the Twitter instance directly
 */
- (void)logOut;

/**
 *  Deletes the local guest session. Does not make a network request to invalidate the session.
 *  @warning This method will soon be deprecated; it is no longer needed as the guest authentication is managed by the session store.
 */
- (void)logOutGuest;

@end

NS_ASSUME_NONNULL_END
