//
//  BEjabberdFileStorageHandler.m
//  AFNetworking
//
//  Created by ben3 on 04/05/2019.
//

#import "BEjabberdFileStorageHandler.h"
#import <ChatSDK/Core.h>
#import <ChatSDKModules/XMPPAdapter.h>

#import <CommonCrypto/CommonDigest.h>

#define file_transfer_namespace @"p1:s3filetransfer"
#define file_id @"fileid"
#define md5 @"md5"

@implementation BEjabberdFileStorageHandler

-(instancetype) init {
    if((self = [super init])) {
        
        [BChatSDK.hook addHook:[BHook hook:^(NSDictionary * data) {
            id<PUser> user = data[bHook_PUser];
            if (user) {
                
                NSString * testUpload = @"testupload";
                
                NSData * data = [testUpload dataUsingEncoding:NSUTF8StringEncoding];
                NSString * md5String = [self MD5WithData:data];
                
                XMPPStream * xmppStream = [BXMPPManager sharedManager].stream;
                
                XMPPIQ * iq = [self fileUploadIq:md5String];
                
                [xmppStream submitIQ:iq].thenOnMain(^id(NSXMLElement * success) {
                    NSXMLElement * query = success.query;
                    
                    // Get the
                    NSString * url = [[query attributeForName:@"upload"] stringValue];
                    NSString * fileId = [[query attributeForName:@"fileid"] stringValue];
                    NSString * md5String = [[query attributeForName:@"md5"] stringValue];
                    
                    url = [url stringByRemovingPercentEncoding];
                    
                    // Now upload the file...
                    NSMutableURLRequest * request = [NSMutableURLRequest new];
                    [request setURL:[NSURL URLWithString:url]];
                    
                    [request setHTTPMethod:@"PUT"];
                    [request setValue:md5String forHTTPHeaderField:@"Content-MD5"];
                    [request setValue:@"`date -R -u`" forHTTPHeaderField:@"Date"];
                    [request setValue:@"" forHTTPHeaderField:@"Content-Type"];
                    
                    NSString * length = [NSString stringWithFormat:@"%d",[data length]];
                    
                    [request setValue:length forHTTPHeaderField:@"Content-Length"];
                    
                    [request setHTTPBody:data];
                    
                    NSURLSession * session = [NSURLSession sharedSession];
                    NSURLSessionDataTask * task = [session uploadTaskWithRequest:request fromData: data completionHandler:^(NSData * data, NSURLResponse * response, NSError * error) {
                        NSLog(@"Ok");
                    }];
                    [task resume];
                    
                    XMPPIQ * iq = [self fileDownloadIq:fileId];
                    
                    [xmppStream submitIQ:iq].thenOnMain(^id(NSXMLElement * success) {
                        NSXMLElement * query = success.query;
                        
                        NSString * url = [[query attributeForName:@"download"] stringValue];
                        url = [url stringByRemovingPercentEncoding];
                        
                        NSMutableURLRequest * request = [NSMutableURLRequest new];
                        [request setURL:[NSURL URLWithString:url]];
                        
                        NSURLSessionDataTask * task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * url, NSURLResponse * response, NSError * error) {
                            NSLog(@"Ok");
                        }];
                        [task resume];
                        
                        NSLog(@"Stop");
                        return Nil;
                    }, Nil);
                    

                    return Nil;
                }, Nil);
                
            }
        }] withName:bHookDidAuthenticate];

        
    }
    return self;
}

-(XMPPIQ *) fileUploadIq: (NSString *) md5String {
    DDXMLElement *query = [DDXMLElement elementWithName:Query xmlns:file_transfer_namespace];
    [query addAttributeWithName:md5 stringValue:md5String];
    
    XMPPIQ * iq = [[XMPPIQ alloc] initWithType:Set
                                            to:self.serverJID
                                     elementID:[BXMPPManager sharedManager].stream.generateUUID
                                         child:query];
    
    [iq addAttributeWithName:From stringValue:[BXMPPManager sharedManager].stream.myJID.bare];
    return iq;
}

-(XMPPIQ *) fileDownloadIq: (NSString *) fileId {
    DDXMLElement *query = [DDXMLElement elementWithName:Query xmlns:file_transfer_namespace];
    [query addAttributeWithName:file_id stringValue:fileId];
    
    XMPPIQ * iq = [[XMPPIQ alloc] initWithType:Get
                                            to:self.serverJID
                                     elementID:[BXMPPManager sharedManager].stream.generateUUID
                                         child:query];
    
    [iq addAttributeWithName:From stringValue:[BXMPPManager sharedManager].stream.myJID.bare];
    return iq;
}


-(XMPPJID *) serverJID {
    return [XMPPJID jidWithString:[BXMPPManager domain]];
}

- (NSString*)MD5WithData: (NSData *) data {
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(data.bytes, data.length, md5Buffer);
    
    NSData * newData = [NSData dataWithBytes:md5Buffer length:CC_MD5_DIGEST_LENGTH];
    return [newData base64EncodedStringWithOptions:kNilOptions];
}

@end
