//
//  BFirebaseUserHandler.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/07/2017.
//
//

#import <Foundation/Foundation.h>
#import <ChatSDKCore/PUsersHandler.h>

@interface BFirebaseUsersHandler : NSObject {
    BOOL _allUsersOn;
}

@property (nonatomic, readwrite) NSMutableArray * allUsers;

-(void) allUsersOn;
-(void) allUsersOff;

@end
