//
//  BInterfaceManager.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 14/09/2016.
//
//

#import <Foundation/Foundation.h>

@protocol PInterfaceFacade;

@interface BInterfaceManager : NSObject

@property (nonatomic, readwrite) id<PInterfaceFacade> a;

+(BInterfaceManager *) sharedManager;

@end
