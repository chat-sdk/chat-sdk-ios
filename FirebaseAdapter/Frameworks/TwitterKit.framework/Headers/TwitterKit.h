//
//  TwitterKit.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#if __has_feature(modules)
@import Accounts;
@import Foundation;
@import Social;
@import UIKit;
@import TwitterCore;
#if __has_include(<DigitsKit/DigitsKit.h>)
@import DigitsKit;
#endif
#else
#import <Accounts/Accounts.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <TwitterCore/TwitterCore.h>
#import <UIKit/UIKit.h>

#if __has_include(<DigitsKit/DigitsKit.h>)
#import <DigitsKit/DigitsKit.h>
#endif
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
#error "TwitterKit doesn't support iOS 6.x and lower. Please, change your minimum deployment target to iOS 7.0"
#endif

#import <TwitterKit/Twitter.h>
#import <TwitterKit/TWTRAPIClient.h>
#import <TwitterKit/TWTRCardConfiguration.h>
#import <TwitterKit/TWTRComposerViewController.h>
#import <TwitterKit/TWTRCollectionTimelineDataSource.h>
#import <TwitterKit/TWTRComposer.h>
#import <TwitterKit/TWTRComposerTheme.h>
#import <TwitterKit/TWTRListTimelineDataSource.h>
#import <TwitterKit/TWTRLogInButton.h>
#import <TwitterKit/TWTROAuthSigning.h>
#import <TwitterKit/TWTRSearchTimelineDataSource.h>
#import <TwitterKit/TWTRShareEmailViewController.h>
#import <TwitterKit/TWTRTimelineDataSource.h>
#import <TwitterKit/TWTRTimelineType.h>
#import <TwitterKit/TWTRTimelineViewController.h>
#import <TwitterKit/TWTRTweet.h>
#import <TwitterKit/TWTRTweetTableViewCell.h>
#import <TwitterKit/TWTRTweetView.h>
#import <TwitterKit/TWTRTweetViewDelegate.h>
#import <TwitterKit/TWTRUser.h>
#import <TwitterKit/TWTRUserTimelineDataSource.h>

/**
 *  `TwitterKit` can be used as an element in the array passed to the `+[Fabric with:]`.
 */
#define TwitterKit [Twitter sharedInstance]
