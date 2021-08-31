/**
 * Copyright (C) 2015-2018 Virgil Security Inc.
 *
 * Lead Maintainer: Virgil Security Inc. <support@virgilsecurity.com>
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
 */

/**
 *  All-in-one headers.
 */

#include "VirgilByteArray.h"
#include "VirgilByteArrayUtils.h"
#include "VirgilChunkCipher.h"
#include "VirgilCipher.h"
#include "VirgilCipherBase.h"
#include "VirgilContentInfo.h"
#include "VirgilCryptoError.h"
#include "VirgilCryptoException.h"
#include "VirgilCustomParams.h"
#include "VirgilDataSink.h"
#include "VirgilDataSource.h"
#include "VirgilKeyPair.h"
#include "VirgilSigner.h"
#include "VirgilSignerBase.h"
#include "VirgilStreamCipher.h"
#include "VirgilStreamSigner.h"
#include "VirgilTinyCipher.h"
#include "VirgilVersion.h"

#include "foundation/asn1/VirgilAsn1Compatible.h"
#include "foundation/asn1/VirgilAsn1Reader.h"
#include "foundation/asn1/VirgilAsn1Writer.h"
#include "foundation/cms/VirgilCMSContent.h"
#include "foundation/cms/VirgilCMSContentInfo.h"
#include "foundation/cms/VirgilCMSEncryptedContent.h"
#include "foundation/cms/VirgilCMSEnvelopedData.h"
#include "foundation/cms/VirgilCMSKeyTransRecipient.h"
#include "foundation/cms/VirgilCMSPasswordRecipient.h"
#include "foundation/VirgilAsymmetricCipher.h"
#include "foundation/VirgilBase64.h"
#include "foundation/VirgilHash.h"
#include "foundation/VirgilHKDF.h"
#include "foundation/VirgilKDF.h"
#include "foundation/VirgilPBE.h"
#include "foundation/VirgilPBKDF.h"
#include "foundation/VirgilRandom.h"
#include "foundation/VirgilSymmetricCipher.h"
#include "foundation/VirgilSystemCryptoError.h"

#include "pfs/VirgilPFS.h"
#include "pfs/VirgilPFSEncryptedMessage.h"
#include "pfs/VirgilPFSInitiatorPrivateInfo.h"
#include "pfs/VirgilPFSInitiatorPublicInfo.h"
#include "pfs/VirgilPFSPrivateKey.h"
#include "pfs/VirgilPFSPublicKey.h"
#include "pfs/VirgilPFSResponderPrivateInfo.h"
#include "pfs/VirgilPFSResponderPublicInfo.h"
#include "pfs/VirgilPFSSession.h"

#include "primitive/VirgilOperationCipher.h"
#include "primitive/VirgilOperationDH.h"
#include "primitive/VirgilOperationHash.h"
#include "primitive/VirgilOperationKDF.h"
#include "primitive/VirgilOperationRandom.h"

#if VIRGIL_CRYPTO_FEATURE_STREAM_IMPL
    #include "stream/VirgilBytesDataSink.h"
    #include "stream/VirgilBytesDataSource.h"
    #include "stream/VirgilStreamDataSink.h"
    #include "stream/VirgilStreamDataSource.h"
#endif /* VIRGIL_CRYPTO_FEATURE_STREAM_IMPL */

#if VIRGIL_CRYPTO_FEATURE_PYTHIA
    #include "pythia/pythia_buf.h"
    #include "pythia/pythia_buf_sizes.h"
    #include "pythia/virgil_pythia_c.h"
    #include "pythia/VirgilPythia.h"
    #include "pythia/VirgilPythiaBlindResult.h"
    #include "pythia/VirgilPythiaContext.h"
    #include "pythia/VirgilPythiaError.h"
    #include "pythia/VirgilPythiaProveResult.h"
    #include "pythia/VirgilPythiaTransformationKeyPair.h"
    #include "pythia/VirgilPythiaTransformResult.h"
#endif /* VIRGIL_CRYPTO_FEATURE_PYTHIA */
