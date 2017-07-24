//
//  TwitterKit.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <TwitterCore/TwitterCore.h>
#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
#error "TwitterKit doesn't support iOS 7.x and lower. Please, change your minimum deployment target to iOS 8.0"
#endif

#import "Twitter.h"
#import "TWTRAPIClient.h"
#import "TWTRCardConfiguration.h"
#import "TWTRCollectionTimelineDataSource.h"
#import "TWTRComposer.h"
#import "TWTRComposerTheme.h"
#import "TWTRComposerViewController.h"
#import "TWTRJSONConvertible.h"
#import "TWTRListTimelineDataSource.h"
#import "TWTRLogInButton.h"
#import "TWTRMediaEntitySize.h"
#import "TWTRMoPubAdConfiguration.h"
#import "TWTRMoPubNativeAdContainerView.h"
#import "TWTRNotificationConstants.h"
#import "TWTROAuthSigning.h"
#import "TWTRSearchTimelineDataSource.h"
#import "TWTRTimelineCursor.h"
#import "TWTRTimelineDataSource.h"
#import "TWTRTimelineDelegate.h"
#import "TWTRTimelineFilter.h"
#import "TWTRTimelineType.h"
#import "TWTRTimelineViewController.h"
#import "TWTRTweet.h"
#import "TWTRTweetCashtagEntity.h"
#import "TWTRTweetDetailViewController.h"
#import "TWTRTweetEntity.h"
#import "TWTRTweetHashtagEntity.h"
#import "TWTRTweetTableViewCell.h"
#import "TWTRTweetUrlEntity.h"
#import "TWTRTweetUserMentionEntity.h"
#import "TWTRTweetView.h"
#import "TWTRTweetViewDelegate.h"
#import "TWTRUser.h"
#import "TWTRUserTimelineDataSource.h"
#import "TWTRVideoMetaData.h"
