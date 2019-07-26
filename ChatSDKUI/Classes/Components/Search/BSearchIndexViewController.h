//
//  SearchTermViewController.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 04/08/2016.
//
//

#import <UIKit/UIKit.h>

@interface BSearchIndexViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray * _indexes;
    NSArray * _selectedIndex;
}

@property (nonatomic, readonly) NSArray * selectedIndex;
@property (nonatomic, readonly) NSMutableArray * indexes;
@property (nonatomic, readwrite) void(^indexSelected)(NSArray * index);

-(instancetype) initWithIndexes: (NSArray *) indexes withCallback: (void(^)(NSArray * index)) callback;

@end
