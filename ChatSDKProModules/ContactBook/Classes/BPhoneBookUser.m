//
//  BPhoneBookUser.m
//  TwoBitTrader
//
//  Created by Ben on 9/6/17.
//  Copyright © 2017 jimijon.com. All rights reserved.
//

#import "BPhoneBookUser.h"
#import <ChatSDK/Core.h>

@implementation BPhoneBookUser

-(id) init {
    if((self = [super init])) {
        self.phoneNumbers = [NSMutableArray new];
        self.emailAddresses = [NSMutableArray new];
    }
    return self;
}

-(NSArray<NSArray<NSString *> *> *) getSearchIndexes {
    NSMutableArray * indexes = [NSMutableArray new];
    
    // Add all the terms
    for (NSString * email in self.emailAddresses) {
        [self addIndex:bUserEmailKey withValue:email toArray: indexes];
    }
    for (NSString * phone in self.phoneNumbers) {
        [self addIndex:bUserPhoneKey withValue:phone toArray: indexes];
    }
    
    [self addIndex:bUserNameKey withValue:self.name toArray: indexes];

    return indexes;
}

-(NSString *) name {
    self.firstName = self.firstName.length ? self.firstName : @"";
    self.lastName = self.lastName.length ? self.lastName : @"";
    return [[NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

-(void) addIndex: (NSString *) index withValue: (NSString *) value toArray: (NSMutableArray *) array {
    [array addObject:@[index, value]];
}

-(BOOL) isContactable {
    return self.name.length && (self.emailAddresses.count || self.phoneNumbers.count);
}

@end
