//
//  BUserPopupView.m
//  Pods
//
//  Created by Simon Smiley-Andrews on 25/08/2017.
//
//

#import "BMentionTextInputView.h"

#import <ChatSDKCore/ChatCore.h>

#import "BUserMentionsAdapter.h"

#import "HKWMentionsAttribute.h"

#import "BMention.h"
#import "BMentionList.h"
#import "BMentionEntity.h"

#import "_HKWMentionsCreationStateMachine.h"

#import "HKWTextView+Plugins.h"
#import "_HKWMentionsPlugin.h"

#import "BMentionViewManager.h"

@interface BMentionTextInputView ()<HKWChooserViewProtocol, UITableViewDelegate, UITableViewDataSource> {
    BMentionList * _mentionList;
    
    bMentionType _mentionType;
}

@property (nonatomic, weak) IBOutlet UITableView * tableView;

@end

@interface BTextInputView()
-(CGFloat)measureHeightOfUITextView:(UITextView *)textView;
-(void)resizeToolbar;
-(void)sendButtonPressed;
@end

@implementation BMentionTextInputView

@synthesize tableView = _tableView;
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
        
        [self setUpTagView];
    }
    return self;
}

- (void)setUpTagView {
    
    // Set up the mentions system
    HKWMentionsChooserPositionMode mode = HKWMentionsChooserPositionModeCustomNoLockNoArrow;
    
    // In this demo, the user may explicitly begin a mention with either the '@' or '+' characters
    NSCharacterSet *controlCharacters = [NSCharacterSet characterSetWithCharactersInString:@"@@"];
    // The user may also begin a mention by typing three characters (set searchLength to 0 to disable)
    HKWMentionsPlugin *mentionsPlugin = [HKWMentionsPlugin mentionsPluginWithChooserMode:mode
                                                                       controlCharacters:controlCharacters
                                                                            searchLength:0];
    
    // NOTE: If you want to see an example of a custom chooser, uncomment the following line.
    mentionsPlugin.chooserViewClass = [BMentionTextInputView class];
    
    // If the text view loses focus while the mention chooser is up, and then regains focus, it will automatically put the mentions chooser back up
    mentionsPlugin.resumeMentionsCreationEnabled = YES;
    // Add edge insets so chooser view doesn't overlap the text view's cosmetic grey border
    mentionsPlugin.chooserViewEdgeInsets = UIEdgeInsetsMake(2, 0.5, 0.5, 0.5);
    self.plugin = mentionsPlugin;
    
    // The mentions plug-in requires a delegate, which provides it with mentions entities in response to a query string
    mentionsPlugin.delegate = self;
    mentionsPlugin.stateChangeDelegate = self;
    
    self.textView.controlFlowPlugin = mentionsPlugin;
    self.textView.externalDelegate = self;
    self.textView.simpleDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notification) {

        NSDictionary * keyboardInfo = notification.userInfo;
        NSValue * keyboardFrameBegin = keyboardInfo[UIKeyboardFrameBeginUserInfoKey];
        CGRect keyboardFrameBeginRect = keyboardFrameBegin.CGRectValue;
        
        _keyboardHeight = keyboardFrameBeginRect.size.height;
    }];
    
    _mentionType = bMentionTypeNormal;
}

- (void)refreshTextViewAttributes {
    
}

+ (id)chooserViewWithFrame:(CGRect)frame delegate:(id<HKWCustomChooserViewDelegate>)delegate {

    BMentionTextInputView * item = (BMentionTextInputView *)[[BMentionViewManager sharedManager] getChooserView];
    
    item.delegate = delegate;
    [item setNeedsLayout];
    
    return item;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"bCell"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

-(void)reloadData {
    [_tableView reloadData];
}

- (void)becomeVisible {
    [self setNeedsLayout];
}

- (void)resetScrollPositionAndHide {
    
}

- (NSInteger)numberOfModelObjects {
    return [_delegate numberOfModelObjects] ? [_delegate numberOfModelObjects] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"bCell"];
    
    id object = [_delegate modelObjectForIndex:indexPath.row];
    
    if ([object isKindOfClass:[BMentionEntity class]]) {
        cell.textLabel.text = ((BMentionEntity *)object).entityName;
    }
    else {
        
        BUserMentionsAdapter * adapter = [_delegate modelObjectForIndex:indexPath.row];
        
        id<PUser> user = adapter.getUser;
        cell.textLabel.text = user.name;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfModelObjects];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_delegate modelObjectSelectedAtIndex:indexPath.row];
}

// Update the frame of the chooser view
- (void)updateUserTagViewFrame: (NSInteger)users {
    
    CGRect screen = [UIScreen mainScreen].bounds;
    
    // We want the min value thats fits in the screen so we don't go under the keyboard or nav bar
    CGFloat height = MIN(users * 44, screen.size.height - [self toolBarHeight] - bMargin - 64 - _keyboardHeight);
    CGRect frame = CGRectMake(0, 65, screen.size.width, height);
    
    if (![BMentionViewManager sharedManager].chooserView) {
        [[BMentionViewManager sharedManager] createChooserViewWithFrame:frame];
    }
    
    // Resize the chooser view
    [[BMentionViewManager sharedManager].chooserView keepAnimatedWithDuration:0.2 layout:^{
        [BMentionViewManager sharedManager].chooserView.frame = frame;
        [self resizeToolbar];
    }];
}

- (CGFloat)toolBarHeight {
    
    CGFloat newHeight = MAX(self.textView.contentSize.height, self.textView.font.lineHeight);//[self getTextBoxTextHeight];
    newHeight = MAX(self.textView.font.lineHeight, [self measureHeightOfUITextView:self.textView]);
    
    // Calcualte the new textview height
    float textBoxHeight = newHeight + bTextViewVerticalPadding;
    
    return textBoxHeight + 2 * bMargin;
}

// Retreive the typed letters in the mention and return the fitlered users
- (void)asyncRetrieveEntitiesForKeyString:(NSString *)keyString
                               searchType:(HKWMentionsSearchType)type
                         controlCharacter:(unichar)character
                               completion:(void (^)(NSArray *, BOOL, BOOL))completionBlock {
    if (!completionBlock) {
        return;
    }
    
    NSArray * threadUsers = self.thread.model.users.allObjects;
    _users = [NSMutableArray new];
    _adaptedUsers = [NSMutableArray new];
    
    // If we have a @ this means it is an urgent mention so we remove the @ to make sure the users are shown
    if ([keyString hasPrefix:@"@"]) {
        keyString = [keyString substringFromIndex:1];
        _mentionType = bMentionTypeUrgent;
    }
    else {
        _mentionType = bMentionTypeNormal;
    }
    
    if (keyString.length == 0 && keyString) {
        _users = threadUsers.mutableCopy;
        
        // We only want to add the 'everyone' user if we haven't started searching yet
        // We add a BMentionEntity object as we still need to comply with the protocol
        // When we are receiving the mention we need to ensure that we don't trigger the functionality with a user called "Everyone"
        // This means we will need to loop over the entityIDs to ensure there is not a user with this entity && the name "Everyone"
        BMentionEntity * everyone = [BMentionEntity entityWithName:@"Everyone" entityId:[[NSUUID UUID] UUIDString]];
        [_adaptedUsers addObject:everyone];
    }
    else {
        
        for (id<PUser> user in threadUsers) {
            
            // If the user's name contains any of the text after the @ then we allow them in our filter
            // We don't mind about the case so include any matching characters
            if ([user.name.lowercaseString containsString:keyString.lowercaseString]) {
                [_users addObject:user];
            }
        }
    }
        
    // We loop through all the users, remove ourselves from the list and add all the others to an adapted array to pass forward
    for (id<PUser> user in _users.mutableCopy) {
        
        if (user == NM.currentUser) {
            [_users removeObject:user];
        }
        else {
            
            // We want to add all our adapted users
            [_adaptedUsers addObject:[[BUserMentionsAdapter alloc] initWithUser:user]];
        }
    }
    
    [self updateUserTagViewFrame:_adaptedUsers.count];
    
    completionBlock(_adaptedUsers, YES, YES);
}

+ (BOOL)string:(NSString *)testString isPrefixOfString:(NSString *)compareString {
    if ([compareString length] == 0
        || [testString length] == 0
        || [compareString length] < [testString length]) {
        return NO;
    }
    NSString *prefix = ([testString length] == [compareString length]
                        ? compareString
                        : [compareString substringToIndex:[testString length]]);
    return [testString compare:prefix
                       options:(NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch)] == NSOrderedSame;
}

- (BOOL)entityCanBeTrimmed:(id<HKWMentionsEntityProtocol>)entity {
    return YES;
}

- (void)mentionsPluginDeactivatedChooserView:(HKWMentionsPlugin *)plugin {
    [self updateUserTagViewFrame:0];
}

-(void) sendButtonPressed {
    
    [self configureUserMentions].thenOnMain(^id(BMentionList * mentionList) {

        // We only want to add this if we have some mentions added in the text - this also ensures it won't be called with an audio message
        if (mentionList.mentionCount) {
        
            // If we have mentions the message can't be empty
            if (self.messageDelegate && [self.messageDelegate respondsToSelector:@selector(sendText:withMeta:)]) {
                [self.messageDelegate sendTextMessage:self.textView.text withMeta:[mentionList serialize]];
            }
    
            self.textView.text = @"";
            [self textViewDidChange:self.textView];
        }
        else {
            // If we have no mentions then call the send as usual in its super class
            [super sendButtonPressed];
        }
        
        return Nil;
    }, nil);
}

- (RXPromise *)configureUserMentions {
    
    RXPromise * promise = [RXPromise new];
    
    NSAttributedString * attributes = self.textView.attributedText;
    
    // If we don't ave any text then we want to return immediately
    // This could just be due to not having a message but also might be them sending an audio message
    if (!self.textView.attributedText.length) {
        [promise resolveWithResult:nil];
    }
    
    NSMutableArray * stringArray = [NSMutableArray new];
    
    // Initialise out mentionList to store the mentions - this also clears the previous mentions
    _mentionList = [[BMentionList alloc] initWithMentions:[NSMutableArray new]];
    
    [attributes enumerateAttributesInRange:NSMakeRange(0, attributes.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        
        HKWMentionsAttribute * attribute = attrs[@"HKWMentionAttributeName"];
        
        if (attribute) {
            
            UIColor * mentionColor = attrs[NSForegroundColorAttributeName];
            
            bMentionType urgency = bMentionTypeNormal;
            
            if ([mentionColor isEqual:[UIColor redColor]]) {
                urgency = bMentionTypeUrgent;
            }
            
            [_mentionList addMention:[BMention entityWithName:attribute.entityName entityId:attribute.entityId location:@(range.location) type:@(urgency)]];
        }
        
        if (range.location + range.length == attributes.length) {
            [promise resolveWithResult:_mentionList];
        }
    }];
    
    return promise;
}

// We check the type of mention added and change the text colour as needed 
- (void)mentionsPlugin:(HKWMentionsPlugin *)plugin
        createdMention:(id<HKWMentionsEntityProtocol>)entity
            atLocation:(NSUInteger)location {
    
    NSAttributedString * attributes = self.textView.attributedText;
    NSMutableAttributedString * mutString = attributes.mutableCopy;
    
    if (_mentionType == bMentionTypeUrgent) {
        [mutString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(location, entity.entityName.length)];
        self.textView.attributedText = mutString;
    }
    
    _mentionType = bMentionTypeNormal;
}

@end
