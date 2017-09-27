//
//  BMentionEntity.h
//  Pods
//
//  Created by Simon Smiley-Andrews on 06/09/2017.
//
//

#import <Foundation/Foundation.h>
#import "HKWMentionsPlugin.h"

// We have the BMentionsEntity to allow us to add other mention objects to the mention array and still agree with the mentions delegate
// This allows us to add an Everyone object to the users. We could also add other kinds of object by setting their name and other data
@interface BMentionEntity : NSObject <HKWMentionsEntityProtocol>

@property (nonatomic, strong) NSString * entityId;
@property (nonatomic, strong) NSString * entityName;
@property (nonatomic, strong) NSDictionary * entityMetadata;

+ (instancetype)entityWithName:(NSString *)name entityId:(NSString *)entityId;

@end
