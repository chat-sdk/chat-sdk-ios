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

#ifndef VIRGIL_PYTHIA_ERROR_H
#define VIRGIL_PYTHIA_ERROR_H

#include <system_error>

#include "../VirgilCryptoError.h"

namespace virgil {
namespace crypto {
namespace pythia {

/**
 * @brief Error category that handles error codes from the system crypto library.
 * @ingroup error
 * @ingroup pythia
 */
class VirgilPythiaErrorCategory : public std::error_category {
public:
    /**
     * @brief Return name of the system crypto category.
     * @return Name of the system crypto category.
     */
    const char* name() const noexcept override;

    /**
     * @brief Return description for the given error code.
     * @param ev Error code.
     * @return Error Description.
     */
    std::string message(int ev) const noexcept override;
};

/**
 * @brief Return singleton instance of the system crypto error category.
 * @return Instance of the syste, crypto error categoty.
 * @ingroup error
 */
const VirgilPythiaErrorCategory& pythia_error_category() noexcept;

/**
 * @brief Handle value returned by underling system crypto library.
 *
 * If given value is an error then VirgilCryptoException will be thrown with appropriate
 * description. If given value is not an error then it will be returned.
 *
 * @param result Value returned by system crypto library.
 * @return Value if it's not an error.
 * @throw VirgilCryptoException with given error code and correspond category, if given value
 * represents an error.
 * @ingroup error
 */
inline int pythia_handler_get_result(int result) {
    if (result >= 0) {
        return result;
    }
    throw VirgilCryptoException(result, pythia_error_category());
}

/**
 * @brief Handle value returned by underling system crypto library.
 *
 * If given value is an error then VirgilCryptoException will be thrown with appropriate
 * description. If given value is not an error then do nothing.
 *
 * @param result Value returned by system crypto library.
 * @throw VirgilCryptoException with given error code and correspond category, if given value
 * represents an error.
 * @ingroup error
 */
inline void pythia_handler(int result) {
    (void)pythia_handler_get_result(result);
}

/**
 * @brief Handle value returned by underling system crypto library.
 *
 * This function is usefull if thrown exception SHOULD be wrapped.
 * Initial exception can be accessed via std::current_exception(), or std::throw_with_nested().
 *
 * If given value is an error then VirgilCryptoException will be thrown with appropriate
 * description. If given value is not an error then it will be returned.
 *
 * @param result Value returned by system crypto library.
 * @param catch_handler Function that can handle the error in a different way.
 *
 * @return Value if it's not an error.
 * @ingroup error
 */
template <typename CatchHandler>
inline int pythia_handler_get_result(int result, CatchHandler catch_handler) {
    if (result >= 0) {
        return result;
    }
    try {
        throw VirgilCryptoException(result, pythia_error_category());
    } catch (...) {
        catch_handler(result);
        return 0;
    }
}

/**
 * @brief Handle value returned by underling system crypto library.
 *
 * This function is usefull if thrown exception SHOULD be wrapped or error can be handled in a
 * different way. Initial exception can be accessed via std::current_exception(), or
 * std::throw_with_nested().
 *
 * If given value is an error then VirgilCryptoException will be thrown with appropriate
 * description. If given value is not an error then do nothing.
 *
 * @param result Value returned by system crypto library.
 * @param catch_handler Function that can handle the error in a different way.
 * @ingroup error
 */
template <typename CatchHandler>
inline void pythia_handler(int result, CatchHandler catch_handler) {
    (void)pythia_handler_get_result<CatchHandler>(result, catch_handler);
}

} // namespace pythia
} // namespace crypto
} // namespace virgil

#endif // VIRGIL_PYTHIA_ERROR_H
