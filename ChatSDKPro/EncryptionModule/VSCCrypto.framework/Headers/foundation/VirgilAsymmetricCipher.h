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

#ifndef VIRGIL_CRYPTO_ASYMMETRIC_CIPHER_H
#define VIRGIL_CRYPTO_ASYMMETRIC_CIPHER_H

#include <cstdlib>
#include <memory>

#include "../VirgilByteArray.h"
#include "../VirgilKeyPair.h"
#include "asn1/VirgilAsn1Compatible.h"

namespace virgil { namespace crypto { namespace foundation {

/**
 * @brief Provides asymmetric ciphers algorithms (PK).
 */
class VirgilAsymmetricCipher : public virgil::crypto::foundation::asn1::VirgilAsn1Compatible {
public:
    /**
     * @name Creation methods
     */
    ///@{
    /**
     * @brief Create object that is not initialized with specific algorithm yet.
     * @see fromAsn1() method to initialize it.
     * @see genKeyPair() method to initialize it.
     * @see setPublicKey() method to initialize it.
     * @see setPrivateKey() method to initialize it.
     */
    VirgilAsymmetricCipher();
    ///@}

    /**
     * @name Info
     */
    ///@{
    /**
     * @brief Provides size in bits of the underlying key.
     * @return Size in bits of the underlying key.
     */
    size_t keySize() const;

    /**
     * @brief Provides the length in bytes of the underlying key.
     * @return Length in bytes of the underlying key.
     */
    size_t keyLength() const;
    ///@}

    /**
     * @name Keys validation
     */
    ///@{
    /**
     * @brief Check if a public-private pair of keys matches.
     *
     * @param publicKey - public key in DER or PEM format.
     * @param privateKey - private key in DER or PEM format.
     * @param privateKeyPassword - private key password if exists.
     *
     * @return true - if public-private pair of keys matches.
     */
    static bool isKeyPairMatch(
            const virgil::crypto::VirgilByteArray& publicKey,
            const virgil::crypto::VirgilByteArray& privateKey,
            const virgil::crypto::VirgilByteArray& privateKeyPassword = virgil::crypto::VirgilByteArray());


    /**
     * @brief Check if given public key has a valid format.
     *
     * Ensure that given public key has the valid format PEM or DER.
     *
     * @param key - public key to be checked.
     * @return true - if public key is valid, false - otherwise.
     */
    static bool isPublicKeyValid(const virgil::crypto::VirgilByteArray& key);

    /**
     * @brief Check if given public key has a valid format.
     *
     * Ensure that given public key has the valid format PEM or DER.
     *
     * @param key - public key to be checked.
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidPublicKey, if public key is invalid.
     */
    static void checkPublicKey(const virgil::crypto::VirgilByteArray& key);

    /**
     * @brief Check if given private key and it's password matches.
     * @param key - private key in DER or PEM format.
     * @param pwd - private key password.
     * @return true - if private key and it's password matches.
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidPrivateKey, if private key is invalid.
     */
    static bool checkPrivateKeyPassword(
            const virgil::crypto::VirgilByteArray& key,
            const virgil::crypto::VirgilByteArray& pwd);


    /**
     * @brief Check if given private key is encrypted.
     * @param privateKey - private key in DER or PEM format.
     * @return true - if private key is encrypted.
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidPrivateKey, if private key is invalid.
     */
    static bool isPrivateKeyEncrypted(const virgil::crypto::VirgilByteArray& privateKey);
    ///@}

    /**
     * @name Keys management
     */
    ///@{
    /**
     * @brief Configures private key.
     *
     * Parse given private key and set it to the current context.
     *
     * @param key - private key in DER or PEM format.
     * @param pwd - private key password if exists.
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidPrivateKey, if private key is invalid.
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidPrivateKeyPassword, if private key password mismatch.
     */
    void setPrivateKey(
            const virgil::crypto::VirgilByteArray& key,
            const virgil::crypto::VirgilByteArray& pwd = virgil::crypto::VirgilByteArray());

    /**
     * @brief Configures public key.
     *
     * Parse given public key and set it to the current context.
     *
     * @param key - public key in DER or PEM format.
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidPublicKey, if public key is invalid.
     */
    void setPublicKey(const virgil::crypto::VirgilByteArray& key);

    /**
     * @brief Generates private and public keys.
     *
     * Generate private and public keys in the current context.
     * @param type - keypair type.
     * @throw VirgilCryptoException with VirgilCryptoError::UnsupportedAlgorithm,
     *     if key pair can't be generated with given type.
     */
    void genKeyPair(VirgilKeyPair::Type type);

    /**
     * @brief Generates private and public keys of the same type from the given context.
     * @param other - donor context.
     * @throw VirgilCryptoException with VirgilCryptoError::NotInitialized,
     *     if donor context does not contain own key pair.
     * @throw VirgilCryptoException with VirgilCryptoError::UnsupportedAlgorithm,
     *     if key pair can't be generated with given type.
     */
    void genKeyPairFrom(const VirgilAsymmetricCipher& other);

    /**
     * @brief Generates private and public keys from the given key material.
     *
     * This is a deterministic key generation algorithm that allows create private key
     * from any secret data, i.e. password.
     *
     * @param type - keypair type.
     * @param keyMaterial - the only data to be used for key generation, must be strong enough.
     *
     * @throw VirgilCryptoException with VirgilCryptoError::UnsupportedAlgorithm,
     *     if key pair can't be generated with given type.
     *
     * @throw VirgilCryptoException with VirgilCryptoError::NotSecure,
     *     if Key Material is weak.
     */
    void genKeyPairFromKeyMaterial(VirgilKeyPair::Type type, const VirgilByteArray& keyMaterial);

    /**
     * @brief Compute shared secret key on a given contexts.
     *
     * Prerequisites:
     *   - Public context MUST handle public key.
     *   - Private context MUST handle private key.
     *   - Both contexts MUST handle Elliptic Curve keys of the same group.
     *
     * @param publicContext - public context.
     * @param privateContext - private context.
     * @throw VirgilCryptoException with VirgilCryptoError::NotInitialized,
     *     if public or private context are not initialized with specific algorithm.
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidArgument, if prerequisites broken.
     */
    static VirgilByteArray computeShared(
            const VirgilAsymmetricCipher& publicContext,
            const VirgilAsymmetricCipher& privateContext);
    ///@}

    /**
     * @name Keys export
     */
    ///@{
    /**
     * @brief Provides private key.
     * @param pwd - private key password (max length is 31 byte).
     * @return Private key in a PKCS#1, SEC1 DER or PKCS#8 structure format.
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidState, if private key can not be exported.
     */
    virgil::crypto::VirgilByteArray exportPrivateKeyToDER(
            const virgil::crypto::VirgilByteArray& pwd = virgil::crypto::VirgilByteArray()) const;

    /**
     * @brief Provides public key.
     * @return Public key in the SubjectPublicKeyInfo DER structure format.
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidState, if public key can not be exported.
     */
    virgil::crypto::VirgilByteArray exportPublicKeyToDER() const;

    /**
     * @brief Provides private key.
     * @param pwd - private key password (max length is 31 byte).
     * @return Private key in a PKCS#1, SEC1 PEM or PKCS#8 structure format.
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidState, if private key can not be exported.
     */
    virgil::crypto::VirgilByteArray exportPrivateKeyToPEM(
            const virgil::crypto::VirgilByteArray& pwd = virgil::crypto::VirgilByteArray()) const;

    /**
     * @brief Provides public key.
     * @return Public key in a SubjectPublicKeyInfo PEM structure format.
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidState, if public key can not be exported.
     */
    virgil::crypto::VirgilByteArray exportPublicKeyToPEM() const;
    ///@}

    /**
     * @name Keys low level management
     *
     * @note Properly works only with Curve25519 keys.
     * @warning Used for internal purposes only.
     */
    ///@{
    /**
     * @brief Return type of the underlying key.
     * @note Properly works only with Curve25519 keys.
     * @throw VirgilCryptoException with VirgilCryptoError::NotInitialized, if key type is unknown.
     */
    virgil::crypto::VirgilKeyPair::Type getKeyType() const;

    /**
     * @brief Change type of the underlying key.
     * @note Properly works only with Curve25519 keys.
     * @throw VirgilCryptoException with VirgilCryptoError::UnsupportedAlgorithm,
     *     if given key type not allowed for this operation.
     */
    void setKeyType(virgil::crypto::VirgilKeyPair::Type keyType);

    /**
     * @brief Return number of the underlying public key.
     *
     * Legend:
     *     * number - Fast EC point if underlying key belongs to the Elliptic Curve group
     *
     * @note Properly works only with X25519 and ED25519 keys.
     * @throw VirgilCryptoException with VirgilCryptoError::UnsupportedAlgorithm,
     *     if given key type not allowed for this operation.
     */
    virgil::crypto::VirgilByteArray getPublicKeyBits() const;

    /**
     * @brief Set number of the underlying public key.
     *
     * Legend:
     *     * number - Fast EC point if underlying key belongs to the Elliptic Curve group
     *
     * @note Properly works only with X25519 and ED25519 keys.
     * @throw VirgilCryptoException with VirgilCryptoError::InvalidArgument,
     *     if given key size is unexpected.
     * @throw VirgilCryptoException with VirgilCryptoError::UnsupportedAlgorithm,
     *     if given key type not allowed for this operation.
     */
    void setPublicKeyBits(const virgil::crypto::VirgilByteArray& bits);
    ///@}

    /**
     * @name Encryption / Decryption
     */
    ///@{
    /**
     * @brief Encrypts given message.
     *
     * Encrypt given message with known public key, configured with @link setPublicKey @endlink method,
     *     or @link genKeyPair @endlink method.
     *
     * @param in - message to be encrypted.
     * @return Encrypted message.
     * @throw VirgilCryptoException with VirgilCryptoError::UnsupportedAlgorithm,
     *     if current context does not support encryption.
     */
    virgil::crypto::VirgilByteArray encrypt(const virgil::crypto::VirgilByteArray& in) const;

    /**
     * @brief Decrypts given message.
     *
     * Decrypt given message with known private key, configured with @link setPrivateKey @endlink method,
     *     or @link genKeyPair @endlink method.
     *
     * @param in - message to be decrypted.
     * @return Decrypted message.
     * @throw VirgilCryptoException with VirgilCryptoError::UnsupportedAlgorithm,
     *     if current context does not support decryption.
     */
    virgil::crypto::VirgilByteArray decrypt(const virgil::crypto::VirgilByteArray& in) const;
    ///@}

    /**
     * @name Sign / Verify
     */
    ///@{
    /**
     * @brief Sign given hash.
     *
     * Sign given hash with known private key, configured with @link setPrivateKey @endlink method,
     *     or @link genKeyPair @endlink method.
     *
     * @param digest - digest to be signed.
     * @param hashType - type of the hash algorithm that was used to get digest
     * @return Signed digest.
     * @throw VirgilCryptoException with VirgilCryptoError::UnsupportedAlgorithm,
     *     if current context does not support sign or connected algorithms (Hash, RNG, etc).
     */
    virgil::crypto::VirgilByteArray sign(const virgil::crypto::VirgilByteArray& digest, int hashType) const;

    /**
     * @brief Verify given hash with given sign.
     *
     * Verify given hash with known public key, configured with @link setPrivateKey @endlink method,
     *     or @link genKeyPair @endlink method, and with given sign.
     *
     * @param digest - digest to be verified.
     * @param sign - signed digest to be used during verification.
     * @param hashType - type of the hash algorithm that was used to get digest
     * @return true if given digest corresponds to the given digest sign, otherwise - false.
     */
    bool verify(
            const virgil::crypto::VirgilByteArray& digest,
            const virgil::crypto::VirgilByteArray& sign, int hashType) const;
    ///@}
    /**
     * @name VirgilAsn1Compatible implementation
     */
    ///@{
    virtual size_t asn1Write(
            virgil::crypto::foundation::asn1::VirgilAsn1Writer& asn1Writer,
            size_t childWrittenBytes = 0) const override;

    virtual void asn1Read(virgil::crypto::foundation::asn1::VirgilAsn1Reader& asn1Reader) override;
    ///@}
public:
    //! @cond Doxygen_Suppress
    VirgilAsymmetricCipher(VirgilAsymmetricCipher&& rhs) noexcept;

    VirgilAsymmetricCipher& operator=(VirgilAsymmetricCipher&& rhs) noexcept;

    virtual ~VirgilAsymmetricCipher() noexcept;
    //! @endcond

private:
    /**
     * @brief If internal state is not initialized with specific algorithm exception will be thrown.
     */
    void checkState() const;

    size_t calculateExportedPublicKeySizeMaxDER() const;
    size_t calculateExportedPublicKeySizeMaxPEM() const;
    size_t calculateExportedPrivateKeySizeMaxDER(size_t encryptionOverhead) const;
    size_t calculateExportedPrivateKeySizeMaxPEM(size_t encryptionOverhead) const;
    VirgilByteArray generateParametersPBES() const;
    static VirgilByteArray adjustBufferWithPEM(const VirgilByteArray& buffer, int size);
    static VirgilByteArray adjustBufferWithDER(const VirgilByteArray& buffer, int size);

private:
    class Impl;

    std::unique_ptr<Impl> impl_;
};

}}}

#endif /* VIRGIL_CRYPTO_ASYMMETRIC_CIPHER_H */
