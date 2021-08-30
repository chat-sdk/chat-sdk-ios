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

#import "VSCBaseCipher.h"

/// Error domain constant for the VSCChunkCipher errors.
NS_SWIFT_NAME(kChunkCipherErrorDomain)
extern NSString * __nonnull const kVSCChunkCipherErrorDomain;

/**
 Class for performing encryption/decryption of relatively small parts of data.
 */
NS_SWIFT_NAME(ChunkCipher)
@interface VSCChunkCipher : VSCBaseCipher

/**
 Encrypts data from stream.

 @param source data to encrypt
 @param destination stream to receive encrypted data
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)encryptDataFromStream:(NSInputStream * __nonnull)source toStream:(NSOutputStream * __nonnull)destination error:(NSError * __nullable * __nullable)error;

/**
 Encrypts data from stream.

 @param source source data to encrypt
 @param destination stream to receive encrypted data
 @param chunkSize chunk size
 @param embedContentInfo determines whether to embed content info the the encrypted data, or not
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)encryptDataFromStream:(NSInputStream * __nonnull)source toStream:(NSOutputStream * __nonnull)destination preferredChunkSize:(size_t)chunkSize embedContentInfo:(BOOL)embedContentInfo error:(NSError * __nullable * __nullable)error;

/**
 Decrypts data from stream.

 @param source source data to decrypt
 @param destination stream to receive decrypted data
 @param password password
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)decryptFromStream:(NSInputStream * __nonnull)source toStream:(NSOutputStream * __nonnull)destination password:(NSString * __nonnull)password error:(NSError * __nullable * __nullable)error;

/**
 Decrypts data from stream.

 @param source source data to decrypt
 @param destination stream to receive decrypted data
 @param recipientId recipient id
 @param privateKey recipient's private key
 @param keyPassword recipient's private key password
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)decryptFromStream:(NSInputStream * __nonnull)source toStream:(NSOutputStream * __nonnull)destination recipientId:(NSData * __nonnull)recipientId privateKey:(NSData * __nonnull)privateKey keyPassword:(NSString * __nullable)keyPassword error:(NSError * __nullable * __nullable)error;

@end
