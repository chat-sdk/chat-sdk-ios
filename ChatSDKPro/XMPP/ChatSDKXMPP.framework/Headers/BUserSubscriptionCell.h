//
//  BUserTableViewCell.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 09/08/2016.
//
//

#import <UIKit/UIKit.h>

#define bUserCellRowHeight 50

@protocol PUserConnection;

@interface BUserSubscriptionCell : UITableViewCell {
    id<PUserConnection> _connection;
}


@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;

-(void) setConnection: (id<PUserConnection>) connection;


@end
