//
//  BModuleHelper.h
//  AFNetworking
//
//  Created by Ben on 2/1/18.
//

#import <Foundation/Foundation.h>

@interface BModuleHelper : NSObject {
    NSMutableArray * _excludingModules;
    NSMutableArray * _activated;
}

// Acivate the core Chat SDK modules
-(void) activateCoreModules;
-(BOOL) activateModuleForName: (NSString *) name;

// Activate the optional modules
-(void) activateModules;
-(void) activateModulesForFirebase;
-(void) activateModulesForXMPP;

-(void) excludeModules: (NSArray *) modules;

@end
