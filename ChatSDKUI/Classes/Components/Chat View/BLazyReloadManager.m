//
//  BLazyReloadManager.m
//  AFNetworking
//
//  Created by ben3 on 13/05/2019.
//

#import "BLazyReloadManager.h"
#import <ChatSDK/UI.h>

@implementation BLazyReloadManager

@synthesize tableView = _tableView;
@synthesize messageManager = _messageManager;
@synthesize loadingMoreMesssages = _loadingMoreMesssages;

-(instancetype) initWithTableView: (UITableView *) tableView messageManager: (BMessageManager *) messageManager {
    if((self = [super init])) {
        _tableView = tableView;
        _messageManager = messageManager;
    }
    return self;
}

-(void) scrollViewDidScroll: (UIScrollView *) scrollView {
    _t_1 = _t;
    _y_1 = _y;
    _t = CACurrentMediaTime();
    _y = scrollView.contentOffset.y;
    float dt = _t - _t_1;
    float ds = _y - _y_1;
    _v = ds / dt;
    float dv = _v - _v_1;
    _a = dv / dt;
    [self loadMessages:scrollView];
}

-(void) loadMessages: (UIScrollView *) scrollView {
    float percentage = scrollView.contentOffset.y / scrollView.frame.size.height;
    if (_active && self.loadMoreMessages != Nil && !_loadingMoreMesssages && percentage < 0.7) {
        _loadingMoreMesssages = YES;
        self.loadMoreMessages().thenOnMain(^id(NSArray<PMessage>* messages)  {
            if (messages.count) {
                float height = scrollView.contentSize.height;
                float offsetY = scrollView.contentOffset.y;
                
                [self.messageManager addMessages: messages];
                [self.tableView reloadData];
                
                float newHeight = scrollView.contentSize.height;
                
                [self.tableView setContentOffset:CGPointMake(0, offsetY + newHeight - height)];
            }
            self.loadingMoreMesssages = NO;
            return Nil;
        }, Nil);
    }
}

// Only lazy load if the user is scrolling the table
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _active = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _active = NO;
}


@end
