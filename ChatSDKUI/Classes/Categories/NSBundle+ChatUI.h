//
//  NSBundle+ChatUI.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 05/04/2015.
//
//

#import <Foundation/Foundation.h>

#define bLogout @"bLogout"
#define bSettings @"bSettings"
#define bAuthenticating @"bAuthenticating"
#define bLogginIn @"bLogginIn"
//#define bProfile @"bProfile"
//#define bLoggingOut @"bLoggingOut"
#define bErrorTitle @"bErrorTitle"
//#define bUserCreatedError @"bUserCreatedError"
#define bContacts @"bContacts"
#define bConversations @"bConversations"
#define bBroadcast @"bBroadcast"
#define bThread @"bThread"
#define bChatRooms @"bChatRooms"
#define bThreadCreationError @"bThreadCreationError"
#define bSearchTerm @"bSearchTerm"

#define bPickFriends @"bPickFriends"

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

//#define bFacebook @"bFacebook"
//#define bFriendsOnChatSDK @"bFriendsOnChatSDK"
#define bInviteFriendsFromFacebook @"bInviteFriendsFromFacebook"
#define bFriendsAdded_i @"bFriendsAdded_i"

//#define bErrorAddingUser_s @"bErrorAddingUser_s"
#define bSuccess @"bSuccess"
#define bAdded @"bAdded"

#define bAdd @"bAdd"
#define bCreatingThread @"bCreatingThread"
#define bLogoutErrorTitle @"bLogoutErrorTitle"

#define bSearch @"bSearch"
#define bSearching @"bSearching"
#define bNoNearbyUsers @"bNoNearbyUsers"

#define bAddUsers @"bAddUsers"

#define bOnline @"bOnline"
#define bOffline @"bOffline"

#define bCreatePublicThread @"bCreatePublicThread"
#define bThreadName @"bThreadName"
#define bCancel @"bCancel"
#define bOk @"bOk"
#define bReset @"bReset"
#define bForgotPassword @"bForgotPassword"
#define bEnterCredentialToResetPassword @"bEnterCredentialToResetPassword"
#define bPasswordResetSuccess @"bPasswordResetSuccess"
#define bUnableToCreateThread @"bUnableToCreateThread"
#define bChat @"bChat"
#define bOptions @"bOptions"
#define bTakePhoto @"bTakePhoto"
#define bTakeVideo @"bTakeVideo"
#define bTakePhotoOrVideo @"bTakePhotoOrVideo"
#define bChooseExistingPhoto @"bChooseExistingPhoto"
#define bChooseExistingVideo @"bChooseExistingVideo"
#define bCurrentLocation @"bCurrentLocation"
#define bSend @"bSend"
#define bRec @"bRec"
#define bWriteSomething @"bWriteSomething"
#define bFlagged @"bFlagged"
#define bFlag @"bFlag"
#define bUnflag @"bUnflag"
#define bHoldToSendAudioMessageError @"bHoldToSendAudioMessageError"
#define bRecording @"bRecording"
#define bCancelled @"bCancelled"
#define bSave @"bSave"
#define bSaving @"bSaving"
#define bGroupName @"bGroupName"
#define bInviteByEmail @"bInviteByEmail"
#define bInviteContact @"bInviteContact"
#define bInviteBySMS @"bInviteBySMS"

#define bTo @"bTo"
#define bEnterNamesHere @"bEnterNamesHere"
#define bSearchedContacts @"bSearchedContacts"
#define bNearbyContacts @"bNearbyContacts"

#define bName @"bName"
#define bPhoneNumber @"bPhoneNumber"
#define bEmail @"bEmail"
#define bDetails @"bDetails"
#define bAddParticipant @"bAddParticipant"
#define bLeaveConversation @"bLeaveConversation"
#define bRejoinConversation @"bRejoinConversation"
#define bParticipants @"bParticipants"
#define bActiveParticipants @"bActiveParticipants"
#define bNoActiveParticipants @"bNoActiveParticipants"
#define bTapHereForContactInfo @"bTapHereForContactInfo"

#define bProfile @"bProfile"
#define bDone @"bDone"
#define bEdit @"bEdit"
#define b_Ago @"b_Ago"

#define bRemoveFriend @"bRemoveFriend"
#define bAddFriend @"bAddFriend"
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
#define bLocation @"bLocation"
#define bCamera @"bCamera"
#define bChoosePhoto @"bChoosePhoto"
#define bChooseVideo @"bChooseVideo"
#define bSticker @"bSticker"
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
#define bLocationMessagesNotSupported @"bLocationMessagesNotSupported"
#define bVideoMessagesNotSupported @"bVideoMessagesNotSupported"

#define bBlock @"bBlock"
#define bUnblock @"bUnblock"

@interface NSBundle (ChatUI)

+(NSBundle *) chatUIBundle;
+(NSString *) t: (NSString *) string;
//+(NSString *) res: (NSString *) name;
+(UIImage *) chatUIImageNamed: (NSString *) name;
+(NSString *) chatUIFilePath: (NSString *) name;

@end
