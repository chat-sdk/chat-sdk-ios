//
//  TWTRNotificationConstants.h
//  TwitterKit
//
//  Copyright © 2016 Twitter. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Constants for notifications that are posted from TwitterKit. These are posted on the default notification center.
 */

#pragma mark - Tweet Action Notifications

/**
 *  Notification indicating a Tweet was selected.
 */
FOUNDATION_EXPORT NSString * const TWTRDidSelectTweetNotification;

/**
 *  Notification indicating the Tweet detail view was shown for a given Tweet.
 */
FOUNDATION_EXPORT NSString * const TWTRDidShowTweetDetailNotification;

/**
 *  Notification indicating the user has selected to share Tweet.
 */
FOUNDATION_EXPORT NSString * const TWTRWillShareTweetNotification;

/**
 *  Notification indicating the Tweet was shared.
 */
FOUNDATION_EXPORT NSString * const TWTRDidShareTweetNotification;

/**
 *  Notification indicating the user has cancelled sharing of the Tweet.
 */
FOUNDATION_EXPORT NSString * const TWTRCancelledShareTweetNotification;

/**
 *  Notification indicating the user has liked a Tweet.
 */
FOUNDATION_EXPORT NSString * const TWTRDidLikeTweetNotification;

/**
 *  Notification indicating the user has unliked a Tweet.
 */
FOUNDATION_EXPORT NSString * const TWTRDidUnlikeTweetNotification;

#pragma mark - Media Notifications

/**
 *  Notification indicating the the playback state of a video
 *  has changed.
 *
 *  object: The UIView emitting these notifications
 *  userInfo: {TWTRVideoPlaybackStateKey: TWTRVideoStateValuePlaying}
 *            {TWTRVideoPlaybackStateKey: TWTRVideoStateValuePaused}
 *            {TWTRVideoPlaybackStateKey: TWTRVideoStateValueCompleted}
 */
FOUNDATION_EXPORT NSString * const TWTRVideoPlaybackStateChangedNotification;

/**
 *  User info key for the state of video playback.
 */
FOUNDATION_EXPORT NSString * const TWTRVideoPlaybackStateKey;

/**
 *  User info values for the state of video playback.
 */
FOUNDATION_EXPORT NSString * const TWTRVideoStateValuePlaying;
FOUNDATION_EXPORT NSString * const TWTRVideoStateValuePaused;
FOUNDATION_EXPORT NSString * const TWTRVideoStateValueCompleted;

#pragma mark - Presentation Notifications

/**
 *  Notification indicating that the video view controller will
 *  be presented.
 *
 *  object: The UIViewController hosting the video view
 *  userInfo: {TWTRVideoTypeKey: TWTRVideoTypeGIF}
 *            {TWTRVideoTypeKey: TWTRVideoTypeStandard}
 *            {TWTRVideoTypeKey: TWTRVideoTypeVine}
 */
FOUNDATION_EXPORT NSString * const TWTRWillPresentVideoNotification;

/**
 *  Notification indicating that the video view controller has
 *  been dismissed.
 *
 *  object: The UIViewController hosting the video view
 */
FOUNDATION_EXPORT NSString * const TWTRDidDismissVideoNotification;

/**
 *  The key to fetch the type of video being displayed in a 
 *  TWTRVideoViewController.
 */
FOUNDATION_EXPORT NSString * const TWTRVideoTypeKey;

/**
 *  User info values for the type of video being displayed
 *  in a TWTRVideoViewController.
 */
FOUNDATION_EXPORT NSString * const TWTRVideoTypeGIF;
FOUNDATION_EXPORT NSString * const TWTRVideoTypeStandard;
FOUNDATION_EXPORT NSString * const TWTRVideoTypeVine;

#pragma mark - Notification User Info

/**
 *  User info key to fetch the associated Tweet in the notification.
 */
FOUNDATION_EXPORT NSString * const TWTRNotificationInfoTweet;


/**
 * A notification which is posted when a user logs out of Twitter.
 * The notification will contain a user dictionary which contains
 * the user id which is being logged out. Note, this notification may
 * be posted as a result of starting the Twitter object.
 */
FOUNDATION_EXPORT NSString * const TWTRUserDidLogOutNotification;
FOUNDATION_EXPORT NSString * const TWTRLoggedOutUserIDKey;

/**
 * A notification which is posted when a user logs in to Twitter.
 * The notification will contain a user dictionary which contains
 * the user id which is being logged in. Note, this notification may
 * be posted as a result of starting the Twitter object.
 */
FOUNDATION_EXPORT NSString * const TWTRUserDidLogInNotification;
FOUNDATION_EXPORT NSString * const TWTRLoggedInUserIDKey;

NS_ASSUME_NONNULL_END
