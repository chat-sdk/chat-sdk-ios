//
//  BStorageManager.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 26/11/2015.
//
//

#import <Foundation/Foundation.h>
#import "CDUser.h"
#import "CDMessage.h"
#import "CDThread.h"
#import "PEntity.h"
#import "CDUserAccount.h"
#import "CDUserConnection.h"
#import "CDGroup.h"
#import "BStorageAdapter.h"

@interface BStorageManager : NSObject {
}

+(BStorageManager *) sharedManager;

@property (nonatomic, readwrite) id<BStorageAdapter> a;


@end
