/*
 * Firebase GeoFire iOS Library
 *
 * Copyright © 2016 Firebase - All Rights Reserved
 * https://firebase.google.com
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binaryform must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY FIREBASE AS IS AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 * EVENT SHALL FIREBASE BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef NSUInteger FirebaseHandle;

@class GeoFire;

typedef NS_ENUM(NSUInteger, GFEventType) {
    GFEventTypeKeyEntered,
    GFEventTypeKeyExited,
    GFEventTypeKeyMoved
};

typedef void (^GFQueryResultBlock) (NSString *key, CLLocation *location);
typedef void (^GFReadyBlock) (void);

/**
 * A GFQuery object handles geo queries at a Firebase location.
 */
@interface GFQuery : NSObject

/**
 * The GeoFire this GFQuery object uses.
 */
@property (nonatomic, strong, readonly) GeoFire *geoFire;

/*!
 Adds an observer for an event type.

 The following event types are supported:


     typedef NS_ENUM(NSUInteger, GFEventType) {
       GFEventTypeKeyEntered, // A key entered the search area
       GFEventTypeKeyExited,  // A key exited the search area
       GFEventTypeKeyMoved    // A key moved within the search area
     };


 The block is called for each event and key.

 Use removeObserverWithFirebaseHandle: to stop receiving callbacks.

 @param eventType The event type to receive updates for
 @param block The block that is called for updates
 @return A handle to remove the observer with
*/

- (FirebaseHandle)observeEventType:(GFEventType)eventType withBlock:(GFQueryResultBlock)block;

/**
 * Adds an observer that is called once all initial GeoFire data has been loaded and the relevant events have
 * been fired for this query. Every time the query criteria is updated, this observer will be called after the
 * updated query has fired the appropriate key entered or key exited events.
 *
 * @param block The block that is called for the ready event
 * @return A handle to remove the observer with
 */
- (FirebaseHandle)observeReadyWithBlock:(GFReadyBlock)block;

/**
 * Removes a callback with a given FirebaseHandle. After this no further updates are received for this handle.
 * @param handle The handle that was returned by observeEventType:withBlock:
 */
- (void)removeObserverWithFirebaseHandle:(FirebaseHandle)handle;

/**
 * Removes all observers for this GFQuery object. Note that with multiple GFQuery objects only this object stops
 * its callbacks.
 */
- (void)removeAllObservers;

@end
