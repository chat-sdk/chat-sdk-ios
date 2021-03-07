//
//  BThreadsViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 24/09/2013.
//  Copyright (c) 2013 deluge. All rights reserved.
//

#import "BPublicThreadsViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@interface BPublicThreadsViewController () {
    UIAlertAction * _okAction;
}

@end

@implementation BPublicThreadsViewController

-(instancetype) init
{
    self = [super initWithNibName:Nil bundle:[NSBundle uiBundle]];
    if (self) {
 
        self.title = [NSBundle t:bChatRooms];
        self.tabBarItem.image = [NSBundle uiImageNamed: @"icn_30_public"];

    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _slideToDeleteDisabled = !BChatSDK.config.allowPublicThreadDeletion;
    
    // Add new group button
    if(BChatSDK.config.allowUsersToCreatePublicChats) {
        
        self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                                target:self
                                                                                                action:@selector(createThread)];
    }
}

-(void) createThread {
    [self createPublicThread];
}

-(void) createPublicThread {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSBundle t:bCreatePublicThread]
                                                                   message:[NSBundle t:bThreadName]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    __weak __typeof__(self) weakSelf = self;
    _okAction = [UIAlertAction actionWithTitle:[NSBundle t:bOk] style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       __typeof__(self) strongSelf = weakSelf;
                                                       if (alert.textFields.count > 0) {
                                                           UITextField *textField = [alert.textFields firstObject];
                                                           
                                                           // Don't create a thread unless connected to the internet
                                                           if (BChatSDK.connectivity.isConnected) {
                                                               
                                                               MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
                                                               hud.label.text = [NSBundle t:bCreatingThread];

                                                               NSString * name = textField.text;
                                                               [BChatSDK.publicThread createPublicThreadWithName:name].thenOnMain(^id(id<PThread> thread) {
                                                                   __typeof__(self) strongSelf = weakSelf;
                                                                   [strongSelf pushChatViewControllerWithThread:thread];
                                                                   [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                                                                   return Nil;
                                                               }, ^id(NSError * error) {
                                                                   __typeof__(self) strongSelf = weakSelf;
                                                                   [strongSelf alertWithTitle:[NSBundle t:bUnableToCreateThread] withError:error];
                                                                   [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                                                                   return error;
                                                               });
                                                           }
                                                       }
                                                   }];
    _okAction.enabled = NO;
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:[NSBundle t:bCancel] style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:_okAction];
    [alert addAction:cancel];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        __typeof__(self) strongSelf = weakSelf;
        textField.delegate = strongSelf;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];

    [self presentViewController:alert animated:YES completion:nil];
    
    [self alertWithTitle:[NSBundle t:bCreatePublicThread] withMessage:[NSBundle t:bThreadName] actions:@[]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    _okAction.enabled = [finalString stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0;
    return YES;
}

-(void) loadThreads {
    [_threads removeAllObjects];
    
    NSArray * threads = [BChatSDK.thread threadsWithType:bThreadTypePublicGroup];
    [_threads addObjectsFromArray:threads];
    
}

-(void) updateLocalNotificationHandler {
    [BChatSDK.ui setLocalNotificationHandler:^(id<PThread> thread) {
        BOOL result = !(thread.type.intValue & bThreadFilterPublic);
        return result;
    }];
}

-(void) updateBadge {
    int count = 0;
    for (id<PThread> thread in _threads) {
        count += thread.unreadMessageCount;
    }
    self.tabBarItem.badgeValue = count > 0 ? [@(count) stringValue] : nil;

}

@end
