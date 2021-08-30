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

#import "VSSKeyStorageConfiguration.h"
#import "VSSKeyEntry.h"
#import "VSSKeyAttrs.h"

extern NSString * __nonnull const kVSSKeyStorageErrorDomain;

/**
 Class responsible for storing, loading, deleting KeyEntries using Keychain.
 */
NS_SWIFT_NAME(KeyStorage)
@interface VSSKeyStorage : NSObject

/**
 Stores key entry.
 @param keyEntry VSSKeyEntry to store
 @param errorPtr NSError pointer to return error if needed
 @return YES if storing succeeded, NO otherwise
 */
- (BOOL)storeKeyEntry:(VSSKeyEntry * __nonnull)keyEntry error:(NSError * __nullable * __nullable)errorPtr;

/**
 Loads key entry.
 @param name NSString with VSSKeyEntry name
 @param errorPtr NSError pointer to return error if needed
 @return VSSKeyEntry if loading succeeded, nil otherwise
 */
- (VSSKeyEntry * __nullable)loadKeyEntryWithName:(NSString * __nonnull)name error:(NSError * __nullable * __nullable)errorPtr;

/**
 Checks whether key entry with given name exists.
 @param name NSString with VSSKeyEntry name
 @return YES if entry with this name exists, NO otherwise
 */
- (BOOL)existsKeyEntryWithName:(NSString * __nonnull)name;

/**
 Removes VSSKeyEntry with given name
 @param name NSString with VSSKeyEntry name
 @param errorPtr NSError pointer to return error if needed
 @return YES if succeeded, NO otherwise
 */
- (BOOL)deleteKeyEntryWithName:(NSString * __nonnull)name error:(NSError * __nullable * __nullable)errorPtr;

/**
 Configuration.
 See VSSKeyStorageConfiguration
 */
@property (nonatomic, copy, readonly) VSSKeyStorageConfiguration * __nonnull configuration;

/**
 Initializer.

 @param configuration Configuration
 @return initialized VSSKeyStorage instance
 */
- (instancetype __nonnull)initWithConfiguration:(VSSKeyStorageConfiguration * __nonnull)configuration NS_DESIGNATED_INITIALIZER;

/**
 Updates key entry.
 
 @param keyEntry New VSSKeyEntry instance
 @param errorPtr NSError pointer to return error if needed
 @return YES if storing succeeded, NO otherwise
 */
- (BOOL)updateKeyEntry:(VSSKeyEntry * __nonnull)keyEntry error:(NSError * __nullable * __nullable)errorPtr;

/**
 Returns all keys in the storage.

 @param errorPtr NSError pointer to return error if needed
 @return NSArray with all keys
 */
- (NSArray<VSSKeyEntry *> * __nullable)getAllKeysWithError:(NSError * __nullable * __nullable)errorPtr;

/**
 Returns all keys tags in the storage.

 @param errorPtr NSError pointer to return error if needed
 @return NSArray with all tags
 */
- (NSArray<VSSKeyAttrs *> * __nullable)getAllKeysAttrsWithError:(NSError * __nullable * __nullable)errorPtr;

/**
 Stores multiple key entries.
 
 @param keyEntries NSArray with VSSKeyEntry instances to store
 @param errorPtr NSError pointer to return error if needed
 @return YES if storing succeeded, NO otherwise
 */
- (BOOL)storeKeyEntries:(NSArray<VSSKeyEntry *> * __nonnull)keyEntries error:(NSError * __nullable * __nullable)errorPtr;

/**
 Removes multiple key entries with given names.

 @param names NSArray with names
 @param errorPtr NSError pointer to return error if needed
 @return YES if succeeded, NO otherwise
 */
- (BOOL)deleteKeyEntriesWithNames:(NSArray<NSString *> * __nonnull)names error:(NSError * __nullable * __nullable)errorPtr;

/**
 Removes ALL keys.
 
 @param errorPtr NSError pointer to return error if needed
 @return YES if succeeded, NO otherwise
 */
- (BOOL)resetWithError:(NSError * __nullable * __nullable)errorPtr;

@end
