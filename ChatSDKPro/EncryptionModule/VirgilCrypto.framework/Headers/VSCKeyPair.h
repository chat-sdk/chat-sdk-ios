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

/// Error domain constant for the `VSCKeyPair` errors.
NS_SWIFT_NAME(kKeyPairErrorDomain)
extern NSString * __nonnull const kVSCKeyPairErrorDomain;

typedef NS_ENUM(NSInteger, VSCKeyType) {
    VSCKeyTypeRSA_256, ///< RSA 1024 bit (not recommended)
    VSCKeyTypeRSA_512, ///< RSA 1024 bit (not recommended)
    VSCKeyTypeRSA_1024, ///< RSA 1024 bit (not recommended)
    VSCKeyTypeRSA_2048, ///< RSA 2048 bit (not recommended)
    VSCKeyTypeRSA_3072, ///< RSA 3072 bit
    VSCKeyTypeRSA_4096, ///< RSA 4096 bit
    VSCKeyTypeRSA_8192, ///< RSA 8192 bit
    VSCKeyTypeEC_SECP192R1, ///< 192-bits NIST curve
    VSCKeyTypeEC_SECP224R1, ///< 224-bits NIST curve
    VSCKeyTypeEC_SECP256R1, ///< 256-bits NIST curve
    VSCKeyTypeEC_SECP384R1, ///< 384-bits NIST curve
    VSCKeyTypeEC_SECP521R1, ///< 521-bits NIST curve
    VSCKeyTypeEC_BP256R1, ///< 256-bits Brainpool curve
    VSCKeyTypeEC_BP384R1, ///< 384-bits Brainpool curve
    VSCKeyTypeEC_BP512R1, ///< 512-bits Brainpool curve
    VSCKeyTypeEC_SECP192K1, ///< 192-bits "Koblitz" curve
    VSCKeyTypeEC_SECP224K1, ///< 224-bits "Koblitz" curve
    VSCKeyTypeEC_SECP256K1, ///< 256-bits "Koblitz" curve
    VSCKeyTypeEC_CURVE25519, ///< Curve25519 as ECP deprecated format
    VSCKeyTypeFAST_EC_X25519,  ///< Curve25519
    VSCKeyTypeFAST_EC_ED25519, ///< Ed25519
};

/**
 Class for generating asymmetric key pairs using a number of alghorithms.
 */
NS_SWIFT_NAME(KeyPair)
@interface VSCKeyPair : NSObject
/**
 Generates a new key pair using curve 25519 without a password.

 @return initialized isntance
 */
- (instancetype __nonnull)init;

/**
 Generates a new key pair.

 @param keyPairType key pair type
 @param password password used to encrypt private key
 @return initialized isntance
 */
- (instancetype __nonnull)initWithKeyPairType:(VSCKeyType)keyPairType password:(NSString * __nullable)password;

/**
 Generates new key pair using given random material (seed).
 
 @param keyPairType key pair type
 @param keyMaterial random key material
 @param password password used to encrypt private key
 @return initialized isntance
 */
- (instancetype __nullable)initWithKeyPairType:(VSCKeyType)keyPairType keyMaterial:(NSData * __nonnull)keyMaterial password:(NSString * __nullable)password;

/**
 Optimized version for generating multiple keys.

 @param numberOfKeys number of keys to generate
 @param keyPairType key pair type
 @return array of keys
 */
+ (NSArray<VSCKeyPair *> * __nonnull)generateMultipleKeys:(NSUInteger)numberOfKeys keyPairType:(VSCKeyType)keyPairType;

/**
 Public key getter.

 @return `NSData` with public key
 */
- (NSData * __nonnull)publicKey;

/**
 Getter for private key.
 
 Private key can be encrypted with password.

 @return `NSData` with private key
 */
- (NSData * __nonnull)privateKey;

/**
 Extracts public key from private key

 @param privateKey private key
 @param password private key password
 @return `NSData` with extracted public key
 */
+ (NSData * __nullable)extractPublicKeyFromPrivateKey:(NSData * __nonnull)privateKey privateKeyPassword:(NSString * __nullable)password;

/**
 Encrypts private key with password

 @param privateKey private key to encrypt
 @param password password
 @return `NSData` with encrypted private key
 */
+ (NSData * __nullable)encryptPrivateKey:(NSData * __nonnull)privateKey privateKeyPassword:(NSString * __nonnull)password;

/**
 Decrypts private key using password

 @param privateKey encrypted private key
 @param password password
 @return `NSData` with decrypted private key
 */
+ (NSData * __nullable)decryptPrivateKey:(NSData * __nonnull)privateKey privateKeyPassword:(NSString * __nonnull)password;

/**
 Check if given private key is encrypted

 @param keyData Private key
 @return `YES` if encrypted, `NO` otherwise
 */
+ (BOOL)isEncryptedPrivateKey:(NSData * __nonnull)keyData;

/**
 Checks if given private key and given password match each other.

 @param keyData Data representing the private key.
 @param password password
 @return `YES` if the private key and the password match, `NO` otherwise.
 */
+ (BOOL)isPrivateKey:(NSData * __nonnull)keyData matchesPassword:(NSString * __nonnull)password;

/**
 Checks if a public key matches private key, so that they are actual key pair.

 @param publicKeyData Data representing a public key.
 @param privateKeyData Data representing a private key.
 @param password Private key password.
 @return `YES` in case when given public key matches given private key, `NO` otherwise
 */
+ (BOOL)isPublicKey:(NSData * __nonnull)publicKeyData matchesPrivateKey:(NSData * __nonnull)privateKeyData withPassword:(NSString * __nullable)password;

/**
 Changes password for the given private key by re-encrypting given private key with a new password.

 @param password Current password for the private key.
 @param newPassword Password which should be used for the private key protection further.
 @param keyData Data object containing the private key.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return Data object containing the private key that is encrypted with the new password
 */
+ (NSData * __nullable)resetPassword:(NSString * __nonnull)password toPassword:(NSString * __nonnull)newPassword forPrivateKey:(NSData * __nonnull)keyData error:(NSError * __nullable * __nullable)error;

/**
 Converts public key to PEM format

 @param publicKey public key
 @return `NSData` with public key in PEM format
 */
+ (NSData * __nullable)publicKeyToPEM:(NSData * __nonnull)publicKey;

/**
 Converts public key to DER format

 @param publicKey public key
 @return `NSData` with public key in DER format
 */
+ (NSData * __nullable)publicKeyToDER:(NSData * __nonnull)publicKey;

/**
 Converts private key to PEM format

 @param privateKey private key
 @return `NSData` with private key in PEM format
 */
+ (NSData * __nullable)privateKeyToPEM:(NSData *__nonnull)privateKey;

/**
 Converts private key to DER format

 @param privateKey private key
 @return `NSData` with private key in DER format
 */
+ (NSData * __nullable)privateKeyToDER:(NSData *__nonnull)privateKey;

/**
 Converts private key to PEM format

 @param privateKey private key
 @param password private key password
 @return `NSData` with private key in PEM format
 */
+ (NSData * __nullable)privateKeyToPEM:(NSData *__nonnull)privateKey privateKeyPassword:(NSString * __nullable)password;

/**
 Converts private key to DER format

 @param privateKey private key
 @param password private key password
 @return `NSData` with private key in DER format
 */
+ (NSData * __nullable)privateKeyToDER:(NSData *__nonnull)privateKey privateKeyPassword:(NSString * __nullable)password;

@end
