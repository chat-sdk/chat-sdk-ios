//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "FUIAuthUtils.h"

NSString *const FUIAuthBundleName = @"FirebaseAuthUI";

NS_ASSUME_NONNULL_BEGIN

@implementation FUIAuthUtils

+ (NSBundle *)bundleNamed:(NSString *)bundleName {
 // NSBundle *frameworkBundle = nil;
    return [self bundleWithFramework:@"ChatSDKFirebaseAdapter" name:bundleName];
    
//  if (bundleName) {
//    NSString *path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
//    frameworkBundle = [NSBundle bundleWithPath:path];
//  } else {
//    frameworkBundle = [NSBundle bundleForClass:[self class]];
//  }
//  return frameworkBundle;
}

+ (UIImage *)imageNamed:(NSString *)name fromBundle:(NSString *)bundleName {
    return [self imageNamed:name framework:@"ChatSDKFirebaseAdapter" bundle:bundleName];
//  NSString *path = [[FUIAuthUtils bundleNamed:bundleName] pathForResource:name ofType:@"png"];
//  return [UIImage imageWithContentsOfFile:path];
}

+(UIImage *) imageNamed: (NSString *) name framework: (NSString *) framework bundle: (NSString *) bundle {
    NSString * path = [NSString stringWithFormat:@"Frameworks/%@.framework/%@.bundle/%@", framework, bundle, name];
    return [UIImage imageNamed:path];
}

+(NSBundle *) bundleWithFramework: (NSString *) framework name: (NSString *) name {
    NSString * path = [self filePathWithFramework:framework name:name];
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:path ofType:@"bundle"]];
}

+(NSString *) filePathWithFramework: (NSString *) framework name: (NSString *) name {
    return [NSString stringWithFormat:@"Frameworks/%@.framework/%@", framework, name];
}


NS_ASSUME_NONNULL_END

@end
