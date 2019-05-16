//
//  BLazyReloadManager.h
//  AFNetworking
//
//  Created by ben3 on 13/05/2019.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RXPromise;
@class BMessageManager;

@interface BLazyReloadManager : NSObject {
    __weak UITableView * _tableView;
    __weak BMessageManager * _messageManager;
    
    float _y_1;
    float _y;
    float _t_1;
    float _t;
    float _v_1;
    float _v;
    float _a;
    
    BOOL _loadingMoreMesssages;
    BOOL _active;
}

@property (nonatomic, readwrite) RXPromise * (^loadMoreMessages)(void);

@property (nonatomic, weak, readonly) UITableView * tableView;
@property (nonatomic, weak, readonly) BMessageManager * messageManager;
@property (nonatomic, readwrite) BOOL loadingMoreMesssages;

-(instancetype) initWithTableView: (UITableView *) tableView messageManager: (BMessageManager *) messageManager;
-(void) scrollViewDidScroll: (UIScrollView *) scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
