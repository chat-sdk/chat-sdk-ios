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


NS_SWIFT_NAME(VirgilRandom)
@interface VSCVirgilRandom : NSObject

/**
 Inherited unavailable initializer.
 
 @return initialized instance
 */
- (instancetype __nonnull)init NS_UNAVAILABLE;

/**
 * @brief Initialize randomization module with personalization data.
 *
 * @param personalInfo (@see section 8.7.1 of NIST Special Publication 800-90A).
 */
- (instancetype __nonnull)initWithPersonalInfo:(NSString * __nonnull)personalInfo;

/**
 * @brief Produce random byte sequence.
 *
 * @param bytesNum number of bytes to be generated.
 * @return Random byte sequence.
 */
- (NSData * __nonnull)randomizeWithBytesNum:(size_t)bytesNum;

/**
 * Returns a pseudo-random number.
 *
 * @return Random Number
 */
- (size_t)randomize;

/**
 * Returns a pseudo-random number between min and max, inclusive.
 *
 * The difference between min and max can be at most
 * <code>std::numeric_limits<size_t>::max() - 1</code>.
 *
 * @param min - minimum value.
 * @param max - maximum value. Must be greater than min.
 * @return Number between min and max, inclusive.
 */
- (size_t)randomizeBetweenMin:(size_t)min andMax:(size_t)max;

@end
