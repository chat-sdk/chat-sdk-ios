//
//  BModuleHelper.h
//  AFNetworking
//
//  Created by Ben on 2/1/18.
//

#import <Foundation/Foundation.h>

@interface BModuleHelper : NSObject

// Acivate the core Chat SDK modules
+(void) activateCoreModules;

// Activate the optional modules
+(void) activateModules;
+(void) activateModulesForFirebase;
+(void) activateModulesForXMPP;

@end
