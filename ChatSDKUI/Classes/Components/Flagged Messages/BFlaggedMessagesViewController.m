//
//  BFlaggedMessagesViewController.m
//  ChatSDK
//
//  Created by Pepe Becker on 04.04.18.
//

#import "BFlaggedMessagesViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@interface BFlaggedMessagesViewController ()

@property (nonatomic, readwrite) NSArray<id<PMessage>> * flaggedMessages;

@end

@implementation BFlaggedMessagesViewController

@synthesize tableView;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = [NSBundle t:bFlagged];
        self.tabBarItem.image = [NSBundle uiImageNamed: @"icn_30_info.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    tableView.keepInsets.equal = 0;
    
    [self updateFlaggedMessages];
    [self addObservers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [tableView setUserInteractionEnabled:YES];
    [self updateFlaggedMessages];
    [tableView reloadData];
}

- (void)addObservers {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [notificationList add:[nc addObserverForName:bNotificationFlaggedMessageAdded object:Nil queue:Nil usingBlock:^(NSNotification *notification) {
        id<PMessage> message = notification.userInfo[bNotificationFlaggedMessageAdded_PMessage];
        NSLog(@"Flagged message added: %@", message.text);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.flaggedMessages.count inSection:0];
        [self updateFlaggedMessages];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }]];
    [notificationList add:[nc addObserverForName:bNotificationFlaggedMessageRemoved object:Nil queue:Nil usingBlock:^(NSNotification *notification) {
        id<PMessage> message = notification.userInfo[bNotificationFlaggedMessageRemoved_PMessage];
        if (message) {
            NSLog(@"Flagged message removed: %@", message.text);
            NSInteger row = [self indexForMessage:message];
            if (row > -1) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                [self updateFlaggedMessages];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                [self updateFlaggedMessages];
                [self.tableView reloadData];
            }
        }
        else {
            [self updateFlaggedMessages];
            [self.tableView reloadData];
        }
    }]];
}

- (void)updateFlaggedMessages {
    self.flaggedMessages = [[NSArray alloc] initWithArray:[BChatSDK.moderation flaggedMessages]];
}

- (NSInteger)indexForMessage:(id<PMessage>)message {
    for (NSUInteger i = 0; i < self.flaggedMessages.count; i++) {
        if (self.flaggedMessages[i].entityID == message.entityID) {
            return i;
        }
    }
    return -1;
}

- (void)dealloc {
    tableView.delegate = Nil;
    tableView.dataSource = Nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.flaggedMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"FlaggedMessagesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == NULL) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    id<PMessage> message = [self.flaggedMessages objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", message.userModel.name, message.text];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [BChatSDK.moderation deleteMessage:self.flaggedMessages[indexPath.row].entityID];
    }];
    delete.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *more = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Unflag" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [BChatSDK.moderation unflagMessage:self.flaggedMessages[indexPath.row].entityID];
    }];
    more.backgroundColor = [UIColor colorWithRed:0.188 green:0.514 blue:0.984 alpha:1];
    
    return @[delete, more];
}

@end
