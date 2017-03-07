//
//  TWTRTweetViewDelegate.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWTRSession;
@class TWTRTweetView;
@class TWTRTweet;
@class TWTRUser;
@protocol TWTRSessionStore;

NS_ASSUME_NONNULL_BEGIN

typedef void (^TWTRAuthenticationCompletionHandler)(id<TWTRSessionStore> sessionStore, NSString *userID);

/**
 Delegate for `TWTRTweetView` to receive updates on the user interacting with this particular Tweet view.
 
    // Create the tweet view
    TWTRTweetView *tweetView = [[TWTRTweetView alloc] initWithTweet:tweet];
    // Set the delegate
    tweetView.delegate = self;
 */
@protocol TWTRTweetViewDelegate <NSObject>

@optional

/**
 *  The tweet view was tapped. Implement to show your own webview if desired using the `permalinkURL` property on the `TWTRTweet` object passed in.
 *  If this method is not implemented and the device is running on iOS 9+ we will deep link into the Twitter application.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param tweet     The Tweet model object being shown.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didSelectTweet:(TWTRTweet *)tweet;

/**
 *  The tweet view image was tapped.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param image     The exact UIImage data shown by the Tweet view.
 *  @param imageURL  The full URL of the image being shown.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didTapImage:(UIImage *)image withURL:(NSURL *)imageURL;

/**
 * The Tweet view video was tapped.
 * If this method is not implemented a video player will be presented.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param videoURL  The full URL of the video being shown.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didTapVideoWithURL:(NSURL *)videoURL;

/**
 *  A URL in the text of a tweet was tapped. Implement to show your own webview rather than opening Safari.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param url       The URL that was tapped.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didTapURL:(NSURL *)url;

/**
 *  Called when the user's profile image is tapped.
 *  If this method is not implemented and the device is running on iOS 9+ we will deep link into the Twitter application.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param user The Twitter user.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didTapProfileImageForUser:(TWTRUser *)user;

/**
 *  The Tweet view "Share" button was tapped and the `UIActivityViewController` was shown.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param tweet     The Tweet model object being shown.
 */
- (void)tweetView:(TWTRTweetView *)tweetView willShareTweet:(TWTRTweet *)tweet;

/**
 *  The share action for a Tweet was completed.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param tweet     The Tweet model object being shown.
 *  @param shareType The share action that was completed. (e.g. `UIActivityTypePostToFacebook`, `UIActivityTypePostToTwitter`, or `UIActivityTypeMail`)
 */
- (void)tweetView:(TWTRTweetView *)tweetView didShareTweet:(TWTRTweet *)tweet withType:(NSString *)shareType;

/**
 *  The share action for a Tweet was cancelled.
 *
 *  @param tweetView The Tweet view handling the share action.
 *  @param tweet     The Tweet model object represented.
 */
- (void)tweetView:(TWTRTweetView *)tweetView cancelledShareTweet:(TWTRTweet *)tweet;

/**
 *  The Tweet view favorite button was tapped and the action was completed with
 *  the Twitter API.
 *
 *  @param tweetView The Tweet view showing this Tweet object.
 *  @param tweet     The Tweet model that was just liked.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didLikeTweet:(TWTRTweet *)tweet;

/**
 *  The Tweet view unfavorite button was tapped and the action was completed with
 *  the Twitter API.
 *
 *  @param tweetView The Tweet view showing this Tweet object.
 *  @param tweet     The Tweet model object that was just unliked.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didUnlikeTweet:(TWTRTweet *)tweet;

/**
 *  Requests authentication from the delegate to use for a network request that requires user context.
 *
 *  @param tweetView                        The Tweet view showing this Tweet object.
 *  @param authenticationCompletionHandler  The completion block that your delegate method must call to provide the necessary
 *                                          user context e.g. user session.
 */
- (void)tweetView:(TWTRTweetView *)tweetView willRequireAuthenticationCompletionHandler:(TWTRAuthenticationCompletionHandler)authenticationCompletionHandler;

#pragma mark - Deprecated

/**
 *  The Tweet view favorite button was tapped and the action was completed with
 *  the Twitter API.
 *
 *  @param tweetView The Tweet view showing this Tweet object.
 *  @param tweet     The Tweet model that was just favorited.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didFavoriteTweet:(TWTRTweet *)tweet __attribute__((deprecated("Use `tweetView:didLikeTweet:`.")));

/**
 *  The Tweet view unfavorite button was tapped and the action was completed with
 *  the Twitter API.
 *
 *  @param tweetView The Tweet view showing this Tweet object.
 *  @param tweet     The Tweet model object that was just unfavorited.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didUnfavoriteTweet:(TWTRTweet *)tweet __attribute__((deprecated("Use `tweetView:didUnlikeTweet:`.")));

@end

NS_ASSUME_NONNULL_END
