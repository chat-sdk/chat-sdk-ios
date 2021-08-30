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
#import "VSCBaseCipher.h"

/// Error domain constant for the VSCCipher errors.
NS_SWIFT_NAME(kCipherErrorDomain)
extern NSString * __nonnull const kVSCCipherErrorDomain;

/**
 Class for encryption/decryption functionality.
 */
NS_SWIFT_NAME(Cipher)
@interface VSCCipher : VSCBaseCipher
/**
 Encrypts the given data using added recepients. Allows to embed info about the recipients so it will be easier to setup decryption.

 @param plainData Data object which needs to be encrypted.
 @param embedContentInfo `YES` in case when some amount of data with recipients info will be added to the result data.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return Data object with encrypted data or `nil` in case of error.
 */
- (NSData * __nullable)encryptData:(NSData * __nonnull)plainData embedContentInfo:(BOOL)embedContentInfo error:(NSError * __nullable * __nullable)error;

/**
 Decrypts data using key-based decryption.

 @param encryptedData Data object containing encrypted data which needs to be decrypted.
 @param recipientId Recipient identifier used for encryption of the data.
 @param privateKey Data object containing the private key for decryption (should correspond the public key used for encryption).
 @param keyPassword Password string used to generate the key pair or `nil`.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return Data object containing the decrypted data or `nil` in case of error.
 */
- (NSData * __nullable)decryptData:(NSData * __nonnull)encryptedData recipientId:(NSData * __nonnull)recipientId privateKey:(NSData * __nonnull)privateKey keyPassword:(NSString * __nullable)keyPassword error:(NSError *__nullable * __nullable)error;

/**
 Decrypts data using password-based decryption.

 @param encryptedData Data object containing encrypted data which needs to be decrypted.
 @param password Password which was used to encrypt the data.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return Data object containing the decrypted data or `nil` in case of error.
 */
- (NSData * __nullable)decryptData:(NSData * __nonnull)encryptedData password:(NSString * __nonnull)password error:(NSError * __nullable * __nullable)error;

@end
