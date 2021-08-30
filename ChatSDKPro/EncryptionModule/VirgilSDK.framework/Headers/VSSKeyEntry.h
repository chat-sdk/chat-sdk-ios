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
 Represents key entry for VSSKeyStorage.
 */
NS_SWIFT_NAME(KeyEntry)
@interface VSSKeyEntry : NSObject

/**
 Factory method which allocates and initalizes VSSKeyEntry instance.

 @param name NSString with key entry name
 @param value Key raw value
 @param meta NSDictionary with any meta data
 @return allocated and initialized VSSCreateCardRequest instance
 */
+ (VSSKeyEntry * __nonnull)keyEntryWithName:(NSString * __nonnull)name value:(NSData * __nonnull)value meta:(NSDictionary<NSString *, NSString *> * __nullable)meta;

/**
 Factory method which allocates and initalizes VSSKeyEntry instance.

 @param name NSString with key entry name
 @param value Key raw value
 @return allocated and initialized VSSKeyEntry instance
 */
+ (VSSKeyEntry * __nonnull)keyEntryWithName:(NSString * __nonnull)name value:(NSData * __nonnull)value;

/**
 NSString with key entry name
 */
@property (nonatomic, readonly, copy) NSString * __nonnull name;

/**
 Key raw value
 */
@property (nonatomic, readonly, copy) NSData * __nonnull value;

/**
 NSDictionary with any meta data
 */
@property (nonatomic, readonly, copy) NSDictionary<NSString *, NSString *> * __nullable meta;

/**
 Unavailable no-argument initializer inherited from NSObject.
 */
- (instancetype __nonnull)init NS_UNAVAILABLE;

@end
