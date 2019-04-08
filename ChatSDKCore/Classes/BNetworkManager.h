//
//  BFirebaseManager.h
//  NekNominate
//
//  Created by Benjamin Smiley-andrews on 24/01/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PNetworkAdapter;

@interface BNetworkManager : NSObject {
}

@property (nonatomic, readwrite) id<PNetworkAdapter> a;

+(BNetworkManager *) sharedManager;




@end
