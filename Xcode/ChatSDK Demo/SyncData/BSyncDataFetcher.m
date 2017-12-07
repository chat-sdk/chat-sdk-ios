//
//  BLocalSyncData.m
//  ChatSDK Demo
//
//  Created by Ben on 12/4/17.
//  Copyright © 2017 deluge. All rights reserved.
//

#import "BSyncDataFetcher.h"

#import <ChatSDK/ChatCore.h>
#import "ChatFirebaseAdapter.h"
#import "SyncData.h"

@implementation BSyncDataFetcher

-(id) initWithUser: (id<PUser>) user {
    if((self = [self init])) {
        _data = [NSMutableDictionary new];
        _listeners = [NSMutableArray new];
        _user = user;
    }
    return self;
}

-(void) pathOn: (NSString *) path {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[self ref: path] observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * snapshot) {
            if(snapshot.value) {
                BSyncItem * item = [[BSyncItem alloc] initWithEntityID: snapshot.key];
                [self addItem: item forPath: path];
            }
        }];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[self ref: path] observeEventType:FIRDataEventTypeChildRemoved withBlock:^(FIRDataSnapshot * snapshot) {
            if(snapshot.value) {
                BSyncItem * item = [[BSyncItem alloc] initWithEntityID: snapshot.key];
                [self removeItem: item forPath: path];
            }
        }];
    });

}

-(void) pathOff: (NSString *) path {
    [[self ref:path] removeAllObservers];
}

-(FIRDatabaseReference *) ref: (NSString *) path {
    return [[FIRDatabaseReference userRef:_user.entityID] child: path];
}

-(void) addItem: (BSyncItem *) item forPath: (NSString *) path {
    if(![self item:item existsForPath:path]) {
        NSMutableArray * items = [self itemsForPath:path];
        [item on];
        [items addObject:item];
        
        for(id<BSyncDataListener> listener in _listeners) {
            if([listener respondsToSelector: @selector(itemAdded:)]) {
                [listener itemAdded: item];
            }
        }
    }
}

-(void) removeItem: (BSyncItem *) item forPath: (NSString *) path {
    if([self item:item existsForPath:path]) {
        NSMutableArray * items = [self itemsForPath:path];
        [item off];
        [items removeObject:item];
        
        for(id<BSyncDataListener> listener in _listeners) {
            if([listener respondsToSelector: @selector(itemRemoved:)]) {
                [listener itemRemoved: item];
            }
        }
    }
}

-(BOOL) item: (BSyncItem *) item existsForPath: (NSString *) path {
    NSMutableArray * items = [self itemsForPath:path];
    for(BSyncItem * i in items) {
        if([i.entityID isEqualToString: item.entityID]) {
            return YES;
        }
    }
    return NO;
}

-(NSMutableArray *) itemsForPath: (NSString *) path {
    NSMutableArray * items = _data[path];
    if(!items) {
        items = [NSMutableArray new];
    }
    return items;
}

-(void) addListener: (id<BSyncDataListener>) listener {
    if(![_listeners containsObject:listener]) {
        [_listeners addObject:listener];
    }
}

-(void) removeListener: (id<BSyncDataListener>) listener {
    if([_listeners containsObject:listener]) {
        [_listeners removeObject:listener];
    }
}

#pragma SyncItemDelegate

-(void) itemChanged: (BSyncItem *) item {
    for(id<BSyncDataListener> listener in _listeners) {
        if([listener respondsToSelector: @selector(itemChanged:)]) {
            [listener itemChanged: item];
        }
    }
}

@end
