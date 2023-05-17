//
//  BContactBookModule.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 13/04/2017.
//
//

#import "BContactBookModule.h"

#import "BPhonebookSearchViewController.h"
#import <ChatSDK/UI.h>


@implementation BContactBookModule

-(void) activate {
    // Users to exclude is set to null because we update this when the view appears anyway
    [BChatSDK.ui addSearchViewController: [[BPhonebookSearchViewController alloc] initWithUsersToExclude:Nil]
                                                        withType: bSearchTypeContactBook
                                                        withName: [NSBundle t:bPhonebook]];

}

@end
