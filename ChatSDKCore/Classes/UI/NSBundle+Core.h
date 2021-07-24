//
//  NSBundle+Core.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 12/07/2017.
//
//

#import <Foundation/Foundation.h>

#define bLogout @"bLogout"
#define bSettings @"bSettings"
#define bAuthenticating @"bAuthenticating"
#define bLogginIn @"bLogginIn"
#define bErrorTitle @"bErrorTitle"
#define bContacts @"bContacts"
#define bConversations @"bConversations"
#define bBroadcast @"bBroadcast"
//#define bThread @"bThread"
#define bChatRooms @"bChatRooms"
#define bThreadCreationError @"bThreadCreationError"
#define bSearchTerm @"bSearchTerm"
#define bWaitingForNetwork @"bWaitingForNetwork"
#define bConnecting @"bConnecting"

#define bSelectUsers @"bSelectUsers"
#define bForwardMessage @"bForwardMessage"

#define bBack @"bBack"
#define bImageSaved @"bImageSaved"
#define bOpenInMaps @"bOpenInMaps"
#define bLocation @"bLocation"
#define bCompose @"bCompose"
#define bCreateGroup @"bCreateGroup"

#define bLoadingFriends @"bLoadingFriends"
#define bLoading @"bLoading"
#define bErrorLoadingFriends @"bErrorLoadingFriends"

#define bInvalidSelection @"bInvalidSelection"
#define bSelectAtLeastOneFriend @"bSelectAtLeastOneFriend"

#define bSuccess @"bSuccess"
#define bAdded @"bAdded"

#define bAdd @"bAdd"
#define bCreatingThread @"bCreatingThread"
#define bLogoutErrorTitle @"bLogoutErrorTitle"

#define bSearch @"bSearch"
#define bSearching @"bSearching"
#define bNoNearbyUsers @"bNoNearbyUsers"
#define bNearbyUsersModuleDisabled @"bNearbyUsersModuleDisabled"

#define bAddUsers @"bAddUsers"

#define bOnline @"online"
#define bOffline @"offline"
#define bActive @"bActive"

#define bCreatePublicThread @"bCreatePublicThread"
#define bThreadName @"bThreadName"
#define bCancel @"bCancel"
#define bOk @"bOk"
#define bReset @"bReset"
#define bLogin @"bLogin"
#define bRegister @"bRegister"
#define bPassword @"bPassword"
#define bForgotPassword @"bForgotPassword"
#define bEnterCredentialToResetPassword @"bEnterCredentialToResetPassword"
#define bPasswordResetSuccess @"bPasswordResetSuccess"
#define bUnableToCreateThread @"bUnableToCreateThread"
#define bChat @"bChat"
#define bOptions @"bOptions"
#define bTakePhoto @"bTakePhoto"

#define bPhotoLibrary @"bPhotoLibrary"
#define bPhotoAlbum @"bPhotoAlbum"
#define bImageUnavailable @"bImageUnavailable"

#define bTakeVideo @"bTakeVideo"
#define bTakePhotoOrVideo @"bTakePhotoOrVideo"
#define bChooseExistingPhoto @"bChooseExistingPhoto"
#define bChooseExistingVideo @"bChooseExistingVideo"
#define bCurrentLocation @"bCurrentLocation"
#define bSend @"bSend"
#define bOpen @"bOpen"
#define bReply @"bReply"
#define bRec @"bRec"
#define bWriteSomething @"bWriteSomething"
#define bSlideToCancel @"bSlideToCancel"
#define bFlagged @"bFlagged"
#define bFlag @"bFlag"
#define bDelete @"bDelete"
#define bDestroy @"bDestroy"
#define bUnflag @"bUnflag"
#define bHoldToSendAudioMessageError @"bHoldToSendAudioMessageError"
#define bRecording @"bRecording"
#define bSecondsRemaining_ @"bSecondsRemaining_"
#define bAudioLengthLimitReached @"bAudioLengthLimitReached"
#define bSendOrDiscardRecording @"bSendOrDiscardRecording"

#define bDestroyAndDelete @"bDestroyAndDelete"


#define bCancelled @"bCancelled"
#define bSave @"bSave"
#define bSaving @"bSaving"
#define bGroupName @"bGroupName"
#define bInviteByEmail @"bInviteByEmail"
#define bInviteContact @"bInviteContact"
#define bInviteBySMS @"bInviteBySMS"

//#define bTo @"bTo"
#define bEnterNamesHere @"bEnterNamesHere"
#define bSearchedContacts @"bSearchedContacts"
#define bNearbyContacts @"bNearbyContacts"

#define bName @"bName"
#define bPhoneNumber @"bPhoneNumber"
#define bEmail @"bEmail"
#define bAddParticipant @"bAddParticipant"
#define bLeaveConversation @"bLeaveConversation"
#define bRejoinConversation @"bRejoinConversation"
#define bParticipants @"bParticipants"
#define bMe @"bMe"
#define bActiveParticipants @"bActiveParticipants"
#define bNoActiveParticipants @"bNoActiveParticipants"
#define bTapHereForContactInfo @"bTapHereForContactInfo"

#define bProfile @"bProfile"
#define bProfilePictures @"bProfilePictures"
#define bAddPictures @"bAddPicture"
#define bDeletePicture @"bDeletePicture"
#define bSetAsDefaultPicture @"bSetAsDefaultPicture"
#define bDeleteLastPictureWarning @"bDeleteLastPictureWarning"
#define bDone @"bDone"
#define bEdit @"bEdit"
#define b_Ago @"b_Ago"

#define bRemoveFromGroup @"bRemoveFromGroup"

#define bAddContact @"bAddContact"
#define bUnblock @"bUnblock"
#define bBlock @"bBlock"
#define b_LeftTheGroup @"b_LeftTheGroup"
#define b_JoinedTheGroup @"b_JoinedTheGroup"

#define bTermsAndConditions @"bTermsAndConditions"

#define bNoMessages @"bNoMessages"
#define bNoNewUsersFoundForThisSearch @"bNoNewUsersFoundForThisSearch"
#define bLastSeen_at_ @"bLastSeen_at_"
#define b_at_ @"b_at_"
#define bToday @"Today"
#define bYesterday @"Yesterday"
#define bYouLeftTheGroup @"bYouLeftTheGroup"
#define bYouJoinedTheGroup @"bYouJoinedTheGroup"
#define bRejoinGroup @"bRejoinGroup"

#define bDefaultThreadName @"bDefaultThreadName"

#define bDeleteContact @"bDeleteContact"
#define bDeleteContactMessage @"bDeleteContactMessage"

#define bTyping @"bTyping"
#define bCamera @"bCamera"
#define bPhoto @"bPhoto"
#define bChoosePhoto @"bChoosePhoto"
#define bChooseVideo @"bChooseVideo"
#define bSticker @"bSticker"
#define bFile @"bFile"
#define bRefreshingUsers @"bRefreshingUsers"
#define bMessageBurst @"bMessageBurst"

#define bSelectYourSearch @"bSelectYourSearch"
#define bPhonebook @"bPhonebook"
#define bSearchWithName @"bSearchWithName"
#define bWarning @"bWarning"
#define bYouMustEnableContactPermissionsToUseThisFunctionalityEnableInTheSettingsApp @"bYouMustEnableContactPermissionsToUseThisFunctionalityEnableInTheSettingsApp"

#define bImageMessagesNotSupported @"bImageMessagesNotSupported"
#define bAudioMessagesNotSupported @"bAudioMessagesNotSupported"
#define bStickerMessagesNotSupported @"bStickerMessagesNotSupported"
#define bFileMessagesNotSupported @"bFileMessagesNotSupported"
#define bLocationMessagesNotSupported @"bLocationMessagesNotSupported"
#define bVideoMessagesNotSupported @"bVideoMessagesNotSupported"

#define bBlock @"bBlock"
#define bUnblock @"bUnblock"

#define bImageMessage @"bImageMessage"
#define bLocationMessage @"bLocationMessage"
#define bAudioMessage @"bAudioMessage"
#define bVideoMessage @"bVideoMessage"
#define bStickerMessage @"bStickerMessage"
#define bFileMessage @"bFileMessage"
#define bEncryptedMessage @"bEncryptedMessage"

#define bAvailable @"bAvailable"
#define bAway @"bAway"
#define bExtendedAway @"bExtendedAway"
#define bBusy @"bBusy"

#define bQRCode @"bQRCode"
#define bContact @"bContact"
#define bImportFailed @"bImportFailed"
#define bImportKeys @"bImportKeys"
#define bExportKeys @"bExportKeys"
#define bEncryption @"bEncryption"
#define bCopiedToClipboard @"bCopiedToClipboard"

// Moderation

#define bRole @"bRole"
#define bViewProfile @"bViewProfile"
#define bSilence @"bSilence"
#define bModeration @"bModeration"
#define bModerator @"moderator"

#define bSearchTerm @"bSearchTerm"
#define bWaitingForNetwork @"bWaitingForNetwork"
#define bConnecting @"bConnecting"

@protocol PMessage;

@interface NSBundle(ChatCore)

+(NSBundle *) coreBundle;
+(NSString *) t: (NSString *) string;
+(NSString *) textForMessage: (id<PMessage>) message;
+(NSString *) t:(NSString *) string bundle: (NSBundle *) bundle localizable: (NSString *) localizable;

@end
