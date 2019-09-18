//
//  EmptyChatView.m
//  ChatSDK-ChatUI
//
//  Created by Kiran Thakur on 28/06/19.
//

#import "EmptyChatView.h"

@interface EmptyChatView ()


@end

@implementation EmptyChatView
@synthesize emptyViewImage;
@synthesize titleLabel;
@synthesize subtitleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

-(void)setText: (NSString *) title setSubTitle: (NSString *) subtitle setEmptyImage: (UIImage*) image {
    [titleLabel setText:title];
    [subtitleLabel setText:subtitle];
    [emptyViewImage setImage:image];
}
    
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
