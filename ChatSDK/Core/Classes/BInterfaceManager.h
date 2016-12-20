//
//  BInterfaceManager.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/09/2016.
//
//

#import <Foundation/Foundation.h>
#import "BDefaultInterfaceAdapter.h"

@interface BInterfaceManager : NSObject

@property (nonatomic, readwrite) BDefaultInterfaceAdapter * a;

+(BInterfaceManager *) sharedManager;

@end
