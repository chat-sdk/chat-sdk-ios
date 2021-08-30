//
// Copyright (C) 2015-2019 Virgil Security Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//     (1) Redistributions of source code must retain the above copyright
//     notice, this list of conditions and the following disclaimer.
//
//     (2) Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in
//     the documentation and/or other materials provided with the
//     distribution.
//
//     (3) Neither the name of the copyright holder nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR ''AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
// IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
// Lead Maintainer: Virgil Security Inc. <support@virgilsecurity.com>
//

#import <Foundation/Foundation.h>

/**
 Provides information about Virgil library version.
 */
NS_SWIFT_NAME(VirgilVersion)
@interface VSCVirgilVersion : NSObject

/**
 Forbidden initializer.

 @return initialized instance
 */
- (instancetype __nonnull)init __unavailable;

/**
 Returns version number in the format MMNNPP (Major, Minor, Patch). (majorVersion() << 16) | (minorVersion() << 8) | patchVersion()

 @return version number in the format MMNNPP (Major, Minor, Patch).
 */
+ (NSUInteger)asNumber;

/**
 Returns version number as string.

 @return version number as string.
 */
+ (NSString * __nonnull)asString;

/**
 Returns major version number.

 @return major version number.
 */
+ (NSUInteger)majorVersion;

/**
 Returns minor version number.

 @return minor version number.
 */
+ (NSUInteger)minorVersion;

/**
 Returns minor version number.

 @return minor version number.
 */
+ (NSUInteger)patchVersion;

/**
 Return version full name.
 
 If current release contains some additional tag, like rc1,
 then version full name will be different from the string returned by method asString(),
 i.e. 1.3.4-rc1, or 1.3.4-coolfeature, etc.

 @return version full name
 */
+ (NSString * __nonnull)fullName;

@end
