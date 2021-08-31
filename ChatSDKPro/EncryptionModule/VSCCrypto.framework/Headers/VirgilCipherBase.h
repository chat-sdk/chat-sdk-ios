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

#ifndef VIRGIL_CIPHER_BASE_H
#define VIRGIL_CIPHER_BASE_H

#include <map>
#include <set>
#include <memory>

#include "VirgilByteArray.h"
#include "VirgilCustomParams.h"

/**
 * @name Forward declaration
 */
/// @{
namespace virgil { namespace crypto { namespace foundation {
class VirgilSymmetricCipher;
}}}
/// @}

namespace virgil { namespace crypto {

/**
 * @brief This class provides configuration methods to all Virgil*Cipher classes.
 */
class VirgilCipherBase {
public:
    /**
     * @brief Initialize submodules.
     */
    VirgilCipherBase();

public:
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
     * @brief Remove recipient with given identifier.
     * @param recipientId Recipient's unique identifier.
     * @note If recipient with given identifier is absent - do nothing.
     */
    void removeKeyRecipient(const VirgilByteArray& recipientId);

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
    bool keyRecipientExists(const VirgilByteArray& recipientId) const;

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
     * @brief Remove recipient with given password.
     * @note If recipient with given password is absent - do nothing.
     */
    void removePasswordRecipient(const VirgilByteArray& pwd);

    /**
     * @brief Check whether recipient with given password exists.
     *
     * Search order:
     *     1. Local structures - useful when cipher is used for encryption.
     *
     * @param password Recipient's unique identifier.
     * @return true if recipient with given password exists, false - otherwise.
     */
    bool passwordRecipientExists(const VirgilByteArray& password) const;

    /**
     * @brief Remove all recipients.
     */
    void removeAllRecipients();
    ///@}
    /**
     * @name Content Info Access / Management
     *
     * Content info is a structure that contains all necessary information
     *     for future decription in secure form.
     */
    ///@{
    /**
     * @brief Return content info.
     *
     * Return Virgil Security Cryptogram, that contains public algorithm parameters that was used for encryption.
     *
     * @note Call this method after encryption process.
     * @throw VirgilCryptoException with VirgilCryptoErrorCode::InvalidOperation,
     *     if this function is used before any encryption operation.
     */
    VirgilByteArray getContentInfo() const;

    /**
     * @brief Create content info object from ASN.1 structure.
     * @param contentInfo Virgil Security Cryptogram.
     * @note Call this method before decryption process.
     * @throw VirgilCryptoException with VirgilCryptoErrorCode::InvalidFormat, if content info can not be parsed.
     */
    void setContentInfo(const VirgilByteArray& contentInfo);

    /**
     * @brief Read content info size as part of the data.
     * @return Size of the content info if it is exist as part of the data, 0 - otherwise.
     */
    static size_t defineContentInfoSize(const VirgilByteArray& data);
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
     * @name Helpers to create shared key with Diffie–Hellman algorithms
     */
    ///@{
    /**
     * @brief Compute shared secret key on a given keys
     *
     * @param publicKey - alice public key.
     * @param privateKey - bob private key.
     * @param privateKeyPassword - bob private key password.
     *
     * @throw VirgilCryptoException - if keys are invalid or keys are not compatible.
     *
     * @warning Keys SHOULD be of the identical type, i.e. both of type Curve25519.
     *
     * @see VirgilKeyPair::generate(const VirgilKeyPair&, const VirgilByteArray&, const VirgilByteArray&)
     */
    static VirgilByteArray computeShared(
            const VirgilByteArray& publicKey,
            const VirgilByteArray& privateKey, const VirgilByteArray& privateKeyPassword = VirgilByteArray());
    ///@}

protected:
    /**
     * @brief Extract content info from the encrypted data and setup it.
     *
     * This function should be used always to filter input encrypted data.
     *
     * @param encryptedData - data that was encrypted.
     * @param isLastChunk - tell filter that given data is the last one.
     * return Encrypted data that is follows content info, if content info was fully extracted, otherwise - empty data.
     */
    VirgilByteArray filterAndSetupContentInfo(const VirgilByteArray& encryptedData, bool isLastChunk);

    /**
     * @brief Configures symmetric cipher for encryption.
     * @note cipher's key randomly generated.
     * @note cipher's input vector is randomly generated.
     */
    void initEncryption();

    /**
     * @brief Stores recipient's password that is used for cipher's key decryption when content becomes available.
     * @param pwd - recipient's password.
     */
    void initDecryptionWithPassword(const VirgilByteArray& pwd);

    /**
     * @brief Stores recipient's information that is used for cipher's key decryption when content becomes available.
     * @param recipientId - recipient's id.
     * @param privateKey - recipient's private key.
     * @param privateKeyPassword - recipient's private key password.
     */
    void initDecryptionWithKey(
            const VirgilByteArray& recipientId,
            const VirgilByteArray& privateKey, const VirgilByteArray& privateKeyPassword);

    /**
     * Return true if one one of the init function was called.
     */
    bool isInited() const;

    /**
     * Return true if underlying symmetric cipher is properly configured for encryption.
     */
    bool isReadyForEncryption() const;

    /**
     * Return true if underlying symmetric cipher is properly configured for decryption.
     */
    bool isReadyForDecryption() const;

    /**
     * @brief Return symmetric cipher configure by one of the methods:
     *     initEncryption(), initDecryptionWithPassword(), initDecryptionWithKey.
     */
    virgil::crypto::foundation::VirgilSymmetricCipher& getSymmetricCipher();

    /**
     * @brief Build VirgilContentInfo object.
     *
     * This method SHOULD be called after encryption process is finished.
     * @note This method SHOULD be called after encryption process is finished.
     */
    void buildContentInfo();

    /**
     * @brief Clear all information related to the cipher.
     *
     * Clear symmetric cipher and correspond internal states.
     * @note This method SHOULD be called after encryption or decryption process is finished.
     * @note You CAN not use symmetric cipher returned by the method @link getSymmetricCipher() @endlink,
     *     after this method call.
     */
    void clear();

public:
    //! @cond Doxygen_Suppress
    VirgilCipherBase(VirgilCipherBase&& rhs) noexcept;

    VirgilCipherBase& operator=(VirgilCipherBase&& rhs) noexcept;

    virtual ~VirgilCipherBase() noexcept;
    //! @endcond

private:
    virtual VirgilByteArray doDecryptWithKey(
            const VirgilByteArray& algorithm, const VirgilByteArray& encryptedKey,
            const VirgilByteArray& privateKey, const VirgilByteArray& privateKeyPassword) const;

    virtual VirgilByteArray doDecryptWithPassword(
            const VirgilByteArray& encryptedKey, const VirgilByteArray& encryptionAlgorithm,
            const VirgilByteArray& password) const;


    /**
     * @brief Configures symmetric cipher for decryption.
     * @note cipher's key is extracted from the content info.
     * @note cipher's input vector is extracted from the content info.
     */
    void accomplishInitDecryption();

private:
    class Impl;

    std::unique_ptr<Impl> impl_;
};

}}

#endif /* VIRGIL_CIPHER_BASE_H */
