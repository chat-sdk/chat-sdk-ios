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

@interface BPublicThreadsViewController ()

@end

@implementation BPublicThreadsViewController

-(instancetype) init
{
    self = [super initWithNibName:Nil bundle:[NSBundle uiBundle]];
    if (self) {
 
        self.title = [NSBundle t:bChatRooms];
        self.tabBarItem.image = [NSBundle uiImageNamed: @"icn_30_public.png"];

    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _slideToDeleteDisabled = !BChatSDK.config.allowPublicThreadDeletion;
    
    // Add new group button
    if(BChatSDK.shared.configuration.allowUsersToCreatePublicChats) {
        
        self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                                target:self
                                                                                                action:@selector(createThread)];
    }
}

-(void) createThread {
    [self createPublicThread];
}

-(void) createPublicThread {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:[NSBundle t:bCreatePublicThread] message:[NSBundle t:bThreadName] delegate:self cancelButtonTitle:[NSBundle t:bCancel] otherButtonTitles:[NSBundle t:bOk], nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
    [alertView show];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    return [[alertView textFieldAtIndex:0].text stringByReplacingOccurrencesOfString:@" " withString:@""].length != 0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // Don't create a thread unless connected to the internet
    if (BChatSDK.connectivity.isConnected) {
        
        if (buttonIndex) {
            
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.label.text = [NSBundle t:bCreatingThread];
            
            __weak __typeof__(self) weakSelf = self;

            NSString * name = [alertView textFieldAtIndex:0].text;
            [BChatSDK.publicThread createPublicThreadWithName:name].thenOnMain(^id(id<PThread> thread) {
                __typeof__(self) strongSelf = self;
                [strongSelf pushChatViewControllerWithThread:thread];
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                return Nil;
            }, ^id(NSError * error) {
                __typeof__(self) strongSelf = self;
                [UIView alertWithTitle:[NSBundle t:bUnableToCreateThread] withError:error];
                [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
                return error;
            });
        }
    }
}

-(void) reloadData {
    [_threads removeAllObjects];
    
    NSArray * threads = [BChatSDK.core threadsWithType:bThreadTypePublicGroup];
    [_threads addObjectsFromArray:threads];
    
    [super reloadData];
}



@end
