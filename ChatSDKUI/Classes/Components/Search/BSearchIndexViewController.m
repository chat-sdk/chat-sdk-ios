//
//  SearchTermViewController.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 04/08/2016.
//
//

#import "BSearchIndexViewController.h"

#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

#define bTableCell @"cell"
#define bSelectedIndexName @"selectedIndexName"
#define bSelectedIndexValue @"selectedIndexValue"

@interface BSearchIndexViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BSearchIndexViewController

@synthesize indexes = _indexes;
@synthesize indexSelected;
@synthesize selectedIndex = _selectedIndex;

-(instancetype) initWithIndexes: (NSArray *) indexes withCallback: (void(^)(NSArray *)) callback {
    if((self = [super initWithNibName:Nil bundle:[NSBundle uiBundle]])) {
        _indexes = [[NSMutableArray alloc] initWithArray:indexes];
        _selectedIndex = [NSArray keyPair:[[NSUserDefaults standardUserDefaults] stringForKey:bSelectedIndexName]
                                   value:[[NSUserDefaults standardUserDefaults] stringForKey:bSelectedIndexValue]];
        
        indexSelected = callback;
        if ((!_selectedIndex || !_selectedIndex.key.length || !_selectedIndex.value.length) && indexes.count) {
            _selectedIndex = indexes.firstObject;
        }
        indexSelected(_selectedIndex);
        self.title = [NSBundle t:bSearchTerm];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedIndex = _indexes[indexPath.row];
    if(indexSelected != Nil) {
        indexSelected(_selectedIndex);
    }
    [[NSUserDefaults standardUserDefaults] setObject:_selectedIndex.key forKey:bSelectedIndexName];
    [[NSUserDefaults standardUserDefaults] setObject:_selectedIndex.value forKey:bSelectedIndexValue];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _indexes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:bTableCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    NSArray * index = _indexes[indexPath.row];
    cell.textLabel.text = index.key;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    cell.accessoryType = [index isEqual:_selectedIndex] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}


@end
