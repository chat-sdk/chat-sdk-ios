//
//  NSXMLElement+Additions.h
//  XMPPChat
//
//  Created by Benjamin Smiley-andrews on 04/08/2016.
//  Copyright © 2016 deluge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXMPPKeys.h"

#import "NSXMLElement+XMPP.h"


@interface NSXMLElement(Additions)

+(NSString *)prettyPrintRawXML:(NSXMLElement *)rawXML;
//+(NSString *)prettyPrintXML:(NSString *)rawXML;
-(void) log;
+(NSXMLElement *) xDataForm;
+(NSXMLElement *) searchQuery;
+(NSXMLElement *) lastOnlineQuery;

-(NSXMLElement *) query;
-(NSXMLElement *) x;

-(void) addAttributes: (NSDictionary *) attributes;

@end
