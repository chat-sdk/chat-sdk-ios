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
 Pfs session
 */
NS_SWIFT_NAME(PfsSession)
@interface VSCPfsSession : NSObject
/**
 Designated initializer.

 @param identifier session identifier
 @param encryptionSecretKey encryption symmetric AES key
 @param decryptionSecretKey decryption symmetric AES key
 @param additionalData additional data for authentication
 @return initialized instance
 */
- (instancetype __nullable)initWithIdentifier:(NSData * __nonnull)identifier encryptionSecretKey:(NSData * __nonnull)encryptionSecretKey decryptionSecretKey:(NSData * __nonnull)decryptionSecretKey additionalData:(NSData * __nonnull)additionalData NS_DESIGNATED_INITIALIZER;

/**
 Inherited unavailable initializer.
 
 @return initialized instance
 */
- (instancetype __nonnull)init NS_UNAVAILABLE;

/**
 Session identifier
 */
@property (nonatomic, readonly) NSData * __nonnull identifier;

/**
 Encryption symmetric AES key
 */
@property (nonatomic, readonly) NSData * __nonnull encryptionSecretKey;

/**
 Decryption symmetric AES key
 */
@property (nonatomic, readonly) NSData * __nonnull decryptionSecretKey;

/**
 Additional data for authentication
 */
@property (nonatomic, readonly) NSData * __nonnull additionalData;

@end
