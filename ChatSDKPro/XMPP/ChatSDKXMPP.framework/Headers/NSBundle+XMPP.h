//
//  NSBundle+ChatUI.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 05/04/2015.
//
//

#import <Foundation/Foundation.h>

#define bIncomingRequests @"bIncomingRequests"
#define bOutgoingRequests @"bOutgoingRequests"
#define bThreadDoesntExist @"bThreadDoesntExist"
#define bJoinGroupToPost @"bJoinGroupToPost"

#define bPasswordNotCorrect @"bPasswordNotCorrect"
#define bUsernameNotCorrect @"bUsernameNotCorrect"
#define bNoLoginTypeSpecified @"bNoLoginTypeSpecified"
#define bStreamWasntReadyToDownloadProfile @"bStreamWasntReadyToDownloadProfile"
#define bUsernameOrPasswordNotSet @"bUsernameOrPasswordNotSet"
#define bRoomIsNoLongerActive @"bRoomIsNoLongerActive"

#define bLoginFailed @"bLoginFailed"
#define bUsernameInvalidCharacters @"bUsernameInvalidCharacters"
#define bUsernameEmpty @"bUsernameEmpty"
#define bAffiliationChangeNotAllowed @"bAffiliationChangeNotAllowed"
#define bUsernamePasswordNotValid @"bUsernamePasswordNotValid"
#define bUnknownXMPPErrorOccurred @"bUnknownXMPPErrorOccurred"

#define bXMPPHostAddressName @"bXMPPHostAddressName"
#define bXMPPDomainName @"bXMPPDomainName"
#define bXMPPPortName @"bXMPPPortName"
#define bXMPPResourceName @"bXMPPResourceName"

#define bServerHostExplanation @"bServerHostExplanation"
#define bRosterServiceExplanation @"bRosterServiceExplanation"

@interface NSBundle (XMPP)

+(NSBundle *) xmppBundle;
+(NSString *) tx: (NSString *) string;
+(UIImage *) xmppImageNamed: (NSString *) name;

@end
