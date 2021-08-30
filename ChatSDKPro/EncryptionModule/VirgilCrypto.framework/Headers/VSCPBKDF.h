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

/// Default size of the securely random data.
NS_SWIFT_NAME(kDefaultRandomBytesSize)
extern const size_t kVSCDefaultRandomBytesSize;

/// Error domain constant for the `VSCPBKDF` errors.
NS_SWIFT_NAME(kPBKDFErrorDomain)
extern NSString * __nonnull const kVSCPBKDFErrorDomain;

/// Enum for the type of an algorithm for a key derivation function.
typedef NS_ENUM(NSInteger, VSCPBKDFAlgorithm) {
    /** 
     * PBKDF2 algorithm for a key derivation. 
     */
    VSCPBKDFAlgorithmPBKDF2
};

/// Enum for the type of a hash function.
typedef NS_ENUM(NSInteger, VSCPBKDFHash) {
    /** 
     * SHA1 hash function. 
     */
    VSCPBKDFHashSHA1 = 1,
    /** 
     * SHA224 hash function. 
     */
    VSCPBKDFHashSHA224,
    /** 
     * SHA256 hash function. 
     */
    VSCPBKDFHashSHA256,
    /** 
     * SHA384 hash function. 
     */
    VSCPBKDFHashSHA384,
    /** 
     * SHA512 hash function. 
     */
    VSCPBKDFHashSHA512
};

/**
 Wrapper object for the key derivation functionality.
 */
NS_SWIFT_NAME(PBKDF)
@interface VSCPBKDF : NSObject
/**
 Data containing the salt for key derivation.
 */
@property (nonatomic, strong, readonly) NSData * __nonnull salt;
/**
 Number of iterations for the key derivation function.
 */
@property (nonatomic, assign, readonly) unsigned int iterations;

/**
 Algorithm used for the key derivation.
 @see `VSCPBKDFAlgorithm`
 */
@property (nonatomic, assign) VSCPBKDFAlgorithm algorithm;

/** 
 Hash function used for the key derivation.
 @see `VSCPBKDFHash`
 */
@property (nonatomic, assign) VSCPBKDFHash hash;

/**
 Designated constructor.
 
 Creates PBKDF wrapper object. By default algoritm is set to `VSCPBKDFAlgorithmPBKDF2` and hash is set to `VSCPBKDFHashSHA384`.

 @param salt Data with salt for key derivation. In case when salt.length == 0 default salt will be generated atomatically.
 @param iterations Count of iterations for key derivation function. In case of 0 - default iterations count will be used automatically.
 @return Instance of the `VSCPBKDF` wrapper.
 */
- (instancetype __nonnull)initWithSalt:(NSData * __nullable)salt iterations:(unsigned int)iterations NS_DESIGNATED_INITIALIZER;

/**
 Involves security check for used parameters.
 
 @warning Enabled by default.

 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)enableRecommendationsCheckWithError:(NSError * __nullable * __nullable)error;

/**
 Ignores security check for used parameters.

 @warning It's strongly recommended to not disable recommendations check.
 
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return `YES` if succeeded, `NO` otherwise
 */
- (BOOL)disableRecommendationsCheckWithError:(NSError * __nullable * __nullable)error;

/**
 Derive key from the given password.

 @param password Password to use when generating key.
 @param size Size of the output sequence, if 0 - then size of the underlying hash will be used.
 @param error `NSError` pointer to get an object in case of error, `nil` - otherwise.
 @return Data with derived key.
 */
- (NSData * __nullable)keyFromPassword:(NSString * __nonnull)password size:(size_t)size error:(NSError * __nullable * __nullable)error;

/**
 Generates cryptographically secure random bytes with required length.

 @param size Required size in bytes of the generated array. When given size equals 0 then `kVSCDefaultRandomBytesSize` will be used instead.
 @return Data with cryptographically secure random bytes.
 */
+ (NSData * __nonnull)randomBytesOfSize:(size_t)size;

@end
