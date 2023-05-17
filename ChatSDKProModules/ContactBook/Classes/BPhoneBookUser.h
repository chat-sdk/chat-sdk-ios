//
//  BPhoneBookUser.h
//  TwoBitTrader
//
//  Created by Ben on 9/6/17.
//  Copyright © 2017 jimijon.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define bIndexKey @"index"
#define bValueKey @"value"

@interface BPhoneBookUser : NSObject

@property (nonatomic, readwrite) NSString * firstName;
@property (nonatomic, readwrite) NSString * lastName;
@property (nonatomic, readwrite) NSMutableArray * emailAddresses;
@property (nonatomic, readwrite) NSMutableArray * phoneNumbers;
@property (nonatomic, readwrite) UIImage * image;

-(NSString *) name;
-(NSArray<NSArray<NSString *> *> *) getSearchIndexes;
-(BOOL) isContactable;

@end
