//
//  TWTRKeychainWrapper.h
//  TWTRAuthentication
//
//  Created by Mustafa Furniturewala on 2/19/14.
//  Copyright (c) 2014 Mustafa Furniturewala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWTRAuthenticationConstants.h"

@interface TWTRKeychainWrapper : NSObject

@property (nonatomic, retain) NSMutableDictionary *keychainItemData;
@property (nonatomic, retain) NSMutableDictionary *genericPasswordQuery;

// Designated initializer.
- (id)initWithAccount:(NSString *)account service:(NSString *)service accessGroup:(NSString *)accessGroup;
- (BOOL)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;

// Initializes and resets the default generic keychain item data.
- (void)resetKeychainItem;

@end
