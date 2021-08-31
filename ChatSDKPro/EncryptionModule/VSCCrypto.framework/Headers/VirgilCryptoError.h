/**
 * Copyright (C) 2015-2018 Virgil Security Inc.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *     (1) Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *
 *     (2) Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in
 *     the documentation and/or other materials provided with the
 *     distribution.
 *
 *     (3) Neither the name of the copyright holder nor the names of its
 *     contributors may be used to endorse or promote products derived from
 *     this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ''AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 * Lead Maintainer: Virgil Security Inc. <support@virgilsecurity.com>
 */

#ifndef VIRGIL_CRYPTO_ERROR_H
#define VIRGIL_CRYPTO_ERROR_H

#include <limits>
#include <system_error>

#include "VirgilCryptoException.h"

namespace virgil { namespace crypto {

/**
 * @brief Specific error codes for the crypto library.
 * @ingroup error
*/
enum class VirgilCryptoError  {
    Reserved = 0, ///< Should not be used.
    EmptyParameter, ///< Given parameter is null or empty.
    ExceededMaxSize, ///< Structure maximum size was exceeded.
    InvalidArgument, ///< Argument given to a function is invalid.
    InvalidFormat, ///< Data format is invalid.
    InvalidPrivateKey, ///< Invalid format of the Private Key.
    InvalidPrivateKeyPassword, ///< Private Key password mismatch.
    InvalidPublicKey, ///< Invalid format of the Public Key.
    InvalidSignature, ///< Invalid format of the Signature.
    InvalidState, ///< Function call prerequisite is broken.
    InvalidAuth, ///< Invalid authentication.
    MismatchSignature, ///< Signature validation failed.
    NotFoundKeyRecipient, ///< Recipient with given identifier is not found.
    NotFoundPasswordRecipient, ///< Recipient with given password is not found.
    NotInitialized, ///< Object is not initialized with specific algorithm, so can't be used.
    NotSecure, ///< Security prerequisite is broken.
    UnsupportedAlgorithm, ///< Algorithm is not supported in the current build.
    Undefined = std::numeric_limits<int>::max()
};

/**
 * @brief This is specific error category that contains information about crypto library errors.
 * @ingroup error
 */
class VirgilCryptoErrorCategory : public std::error_category {
public:
    /**
     * @return Category name.
     */
    const char* name() const noexcept override;

    /**
     *
     * @param ev Error value.
     * @return Error description for given error value.
     * @see VirgilCryptoError for specific error values.
     */
    std::string message(int ev) const noexcept override;
};

/**
 * @brief Return singleton instance of the crypto error category.
 * @return Instance of the crypto error categoty.
 * @ingroup error
 */
const VirgilCryptoErrorCategory& crypto_category() noexcept;

/**
 * @brief Build exception with given error value and corresond error category.
 * @param ev Error value.
 * @return Exception with given error value and corresond error category.
 * @see VirgilCryptoError for specific error values.
 * @ingroup error
 */
inline VirgilCryptoException make_error(VirgilCryptoError ev) {
    return VirgilCryptoException(static_cast<int>(ev), crypto_category());
}

/**
 * @brief Build exception with given error value and corresond error category.
 * @param ev Error value.
 * @param what Additional error description.
 * @return Exception with given error value and corresond error category.
 * @see VirgilCryptoError for specific error values.
 * @ingroup error
 */
inline VirgilCryptoException make_error(VirgilCryptoError ev, const std::string& what) {
    return VirgilCryptoException(static_cast<int>(ev), crypto_category(), what);
}

/**
 * @brief Build exception with given error value and corresond error category.
 * @param ev Error value.
 * @param what Additional error description.
 * @return Exception with given error value and corresond error category.
 * @see VirgilCryptoError for specific error values.
 * @ingroup error
 */
inline VirgilCryptoException make_error(VirgilCryptoError ev, const char* what) {
    return VirgilCryptoException(static_cast<int>(ev), crypto_category(), what);
}
}}


#endif //VIRGIL_CRYPTO_ERROR_H
