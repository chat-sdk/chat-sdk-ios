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

#ifndef VIRGIL_CRYPTO_CONTENT_INFO_H
#define VIRGIL_CRYPTO_CONTENT_INFO_H

#include "VirgilCustomParams.h"
#include "foundation/asn1/VirgilAsn1Compatible.h"

#include <memory>
#include <functional>

namespace virgil { namespace crypto {

/**
 * High level API to the VirgilContentInfo structure.
 */
class VirgilContentInfo : public foundation::asn1::VirgilAsn1Compatible {
public:
    /**
     * @name VirgilAsn1Compatible implementation
     * @code
     * Marshalling format:
     *     VirgilContentInfo ::= SEQUENCE {
     *         version ::= INTEGER { v0(0) },
     *         cmsContent ContentInfo, -- Imports from RFC 5652
     *         customParams [0] IMPLICIT VirgilCustomParams OPTIONAL
     *     }
     * @endcode
     */
    ///@{
    size_t asn1Write(
            virgil::crypto::foundation::asn1::VirgilAsn1Writer& asn1Writer,
            size_t childWrittenBytes = 0) const override;

    void asn1Read(virgil::crypto::foundation::asn1::VirgilAsn1Reader& asn1Reader) override;
    ///@}
public:
    /**
     * @brief PIMPL initialization.
     */
    VirgilContentInfo();
    /**
     * @name Recipient management
     */
    ///@{
    /**
     * @brief Add recipient defined with id and public key.
     * @param recipientId Recipient's unique identifier, MUST not be empty.
     * @param publicKey Recipient's public key, MUST not be empty.
     * @throw VirgilCryptoException with VirgilCryptoErrorCode::InvalidArgument, if invalid arguments are given.
     */
    void addKeyRecipient(const VirgilByteArray& recipientId, const VirgilByteArray& publicKey);

    /**
     * @brief Check whether recipient with given identifier exists.
     *
     * Search order:
     *     1. Local structures - useful when cipher is used for encryption.
     *     2. ContentInfo structure - useful when cipher is used for decryption.
     *
     * @param recipientId Recipient's unique identifier.
     * @return true if recipient with given identifier exists, false - otherwise.
     */
    bool hasKeyRecipient(const VirgilByteArray& recipientId) const;

    /**
     * @brief Remove recipient with given identifier.
     * @param recipientId Recipient's unique identifier.
     * @note If recipient with given identifier is absent - do nothing.
     */
    void removeKeyRecipient(const VirgilByteArray& recipientId);

    /**
     * @brief Remove all recipients defined with identifier.
     */
    void removeKeyRecipients();

    /**
     * @brief Add recipient defined with password.
     *
     * Use it for password based encryption.
     *
     * @param pwd Recipient's password, MUST not be empty.
     * @throw VirgilCryptoException with VirgilCryptoErrorCode::InvalidArgument, if empty argument are given.
     */
    void addPasswordRecipient(const VirgilByteArray& pwd);

    /**
     * @brief Check whether recipient with given password exists.
     *
     * Search order:
     *     1. Local structures - useful when cipher is used for encryption.
     *
     * @param password Recipient's unique identifier.
     * @return true if recipient with given password exists, false - otherwise.
     */
    bool hasPasswordRecipient(const VirgilByteArray& password) const;

    /**
     * @brief Remove recipient with given password.
     * @note If recipient with given password is absent - do nothing.
     */
    void removePasswordRecipient(const VirgilByteArray& pwd);

    /**
     * @brief Remove all recipients defined with password.
     */
    void removePasswordRecipients();

    /**
     * @brief Remove all recipients.
     */
    void removeAllRecipients();
    ///@}

    /**
     * @name Custom parameters Access / Management
     *
     * Custom parameters is a structure that contains additional user defined information
     *     about encrypted data.
     * @note This information is stored as part of the content info in unencrypted format.
     */
    ///@{
    /**
     * @brief Provide access to the object that handles custom parameters.
     * @note Use this method to add custom parameters to the content info object.
     * @note Use this method before encryption process.
     */
    VirgilCustomParams& customParams();

    /**
     * @brief Provide readonly access to the object that handles custom parameters.
     * @note Use this method to read custom parameters from the content info object.
     */
    const VirgilCustomParams& customParams() const;
    ///@}

    /**
     * @name Helpers
     */
    ///@{
    static size_t defineSize(const VirgilByteArray& contentInfoData);
    ///@}

private:
    /**
     * @name Encrypted content management
     *
     * @note Designed for internal use only.
     */
    ///@{
    /**
     * @brief Iterate over key recipients.
     */
    VirgilByteArray decryptKeyRecipient(
            const VirgilByteArray& recipientId,
            std::function<VirgilByteArray(
                    const VirgilByteArray& algorithm, const VirgilByteArray& encryptedKey)> decrypt) const;

    /**
     * @brief Iterate over password recipients.
     */
    VirgilByteArray decryptPasswordRecipient(
            std::function<VirgilByteArray(
                    const VirgilByteArray& algorithm, const VirgilByteArray& encryptedKey)> decrypt) const;

    struct EncryptionResult {
        VirgilByteArray encryptionAlgorithm;
        VirgilByteArray encryptedContent;
    };

    void encryptKeyRecipients(std::function<EncryptionResult(const VirgilByteArray& publicKey)> encrypt);

    void encryptPasswordRecipients(std::function<EncryptionResult(const VirgilByteArray& pwd)> encrypt);

    void setContentEncryptionAlgorithm(const VirgilByteArray& contentEncryptionAlgorithm);

    VirgilByteArray getContentEncryptionAlgorithm() const;

    bool isReadyForEncryption();

    bool isReadyForDecryption();

    friend class VirgilCipherBase;
    ///@}

public:
    //! @cond Doxygen_Suppress
    VirgilContentInfo(VirgilContentInfo&& rhs) noexcept;

    VirgilContentInfo& operator=(VirgilContentInfo&& rhs) noexcept;

    ~VirgilContentInfo() noexcept;
    //! @endcond

private:
    class Impl;

    std::unique_ptr<Impl> impl_;
};

}}

#endif //VIRGIL_CRYPTO_CONTENT_INFO_H
