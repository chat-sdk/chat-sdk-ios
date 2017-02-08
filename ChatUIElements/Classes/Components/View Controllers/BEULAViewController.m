//
//  BEULAViewController.m
//  Chat SDK
//
//  Created by Simon Smiley-Andrews on 16/02/2015.
//  Copyright (c) 2015 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import "BEULAViewController.h"

#import <ChatSDK/ChatCore.h>
#import <ChatSDK/ChatUI.h>

#define bEULA @"EULA"
#define bEULAEnglish @"EULAEnglish"

@interface BEULAViewController ()

@end

@implementation BEULAViewController

@synthesize textView;

- (id)init {
    
    self = [super initWithNibName:@"BEULAViewController" bundle:[NSBundle chatUIBundle]];
    if (self) {
        // Custom initialization
        self.title = [[NSBundle t:bTermsAndConditions] uppercaseString];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bBack] style: UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    NSString * filePath = [[NSBundle mainBundle] pathForResource:[NSBundle res: @"EULA"] ofType:@"plist"];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    NSArray * EULATerms = [NSArray arrayWithArray:[dict objectForKey:bEULAEnglish]];
    
    NSMutableString * EULA = [NSMutableString new];
    
    for (NSString * string in EULATerms) {
        [EULA appendString:[NSString stringWithFormat:@"%@\n\n", string]];
    }
    
    textView.text = EULA;
    textView.textAlignment = NSTextAlignmentJustified;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [textView setContentOffset:CGPointZero];
    textView.contentInset = UIEdgeInsetsZero;
}

- (void)backButtonPressed {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
