/** @file FIRPhoneNumberProvider.h
    @brief Firebase Auth SDK
    @copyright Copyright 2017 Google Inc.
    @remarks Use of this SDK is subject to the Google APIs Terms of Service:
        https://developers.google.com/terms/
 */

#import <Foundation/Foundation.h>

#import "FIRAuth.h"
#import "FIRAuthSwiftNameSupport.h"

@class FIRPhoneAuthCredential;

NS_ASSUME_NONNULL_BEGIN

/** @var FIRPhoneAuthProviderID
    @brief A string constant identifying the phone identity provider.
 */
extern NSString *const FIRPhoneAuthProviderID FIR_SWIFT_NAME(PhoneAuthProviderID);

/** @typedef FIRVerificationResultCallback
    @brief The type of block invoked when a request to send a verification code has finished.

    @param verificationID On success, the verification ID provided, nil otherwise.
    @param error On error, the error that occured, nil otherwise.
 */
typedef void (^FIRVerificationResultCallback)(NSString *_Nullable verificationID,
                                              NSError *_Nullable error)
    FIR_SWIFT_NAME(VerificationResultCallback);

/** @class FIRPhoneNumberProvider
    @brief A concrete implementation of @c FIRAuthProvider for Phone Auth Providers.
 */
FIR_SWIFT_NAME(PhoneAuthProvider)
@interface FIRPhoneAuthProvider : NSObject

/** @fn provider
    @brief Returns an instance of @c FIRPhoneAuthProvider for the default @c FIRAuth object.
 */
+ (instancetype)provider FIR_SWIFT_NAME(provider());

/** @fn providerWithAuth:
    @brief Returns an instance of @c FIRPhoneAuthProvider for the provided @c FIRAuth object.

    @param auth The auth object to associate with the @c PhoneauthProvider instance.
 */
+ (instancetype)providerWithAuth:(FIRAuth *)auth FIR_SWIFT_NAME(provider(auth:));

/** @fn verifyPhoneNumber:completion:
    @brief Starts the phone number authentication flow by sending a verifcation code to the
        specified phone number.

    @param phoneNumber The phone number to be verified.
    @param completion The callback to be invoked when the verification flow is finished.
 */
- (void)verifyPhoneNumber:(NSString *)phoneNumber
               completion:(nullable FIRVerificationResultCallback)completion;

/** @fn credentialWithVerificationID:verificationCode:
    @brief Creates an @c FIRAuthCredential for the phone number provider identified by the
        verification ID and verification code.

    @param verificationID The verification ID obtained from invoking @c
        verifyPhoneNumber:completion:
    @param verificationCode The verification code obtained from the user.
    @return The corresponding @c FIRAuthCredential for the verification ID and verification code
        provided.
 */
- (FIRPhoneAuthCredential *)credentialWithVerificationID:(NSString *)verificationID
                                        verificationCode:(NSString *)verificationCode;

/** @fn init
    @brief Please use the @c provider or @providerWithAuth: methods to obtain an instance of @c
        FIRPhoneAuthProvider.
 */
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
