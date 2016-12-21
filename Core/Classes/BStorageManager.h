//
//  BStorageManager.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 26/11/2015.
//
//

#import <Foundation/Foundation.h>

@protocol BStorageAdapter;

@interface BStorageManager : NSObject {
}

+(BStorageManager *) sharedManager;

@property (nonatomic, readwrite) id<BStorageAdapter> a;


@end
