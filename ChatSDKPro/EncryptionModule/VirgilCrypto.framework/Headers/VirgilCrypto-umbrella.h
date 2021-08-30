#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "VSCBaseCipher.h"
#import "VSCByteArrayUtils.h"
#import "VSCChunkCipher.h"
#import "VSCCipher.h"
#import "VSCFoundationCommons.h"
#import "VSCHash.h"
#import "VSCKeyPair.h"
#import "VSCPBKDF.h"
#import "VSCSigner.h"
#import "VSCStreamCipher.h"
#import "VSCStreamSigner.h"
#import "VSCTinyCipher.h"
#import "VSCVirgilRandom.h"
#import "VSCVirgilVersion.h"
#import "VSCPfs.h"
#import "VSCPfsEncryptedMessage.h"
#import "VSCPfsInitiatorPrivateInfo.h"
#import "VSCPfsInitiatorPublicInfo.h"
#import "VSCPfsPrivateKey.h"
#import "VSCPfsPublic.h"
#import "VSCPfsPublicKey.h"
#import "VSCPfsResponderPrivateInfo.h"
#import "VSCPfsResponderPublicInfo.h"
#import "VSCPfsSession.h"

FOUNDATION_EXPORT double VirgilCryptoVersionNumber;
FOUNDATION_EXPORT const unsigned char VirgilCryptoVersionString[];

