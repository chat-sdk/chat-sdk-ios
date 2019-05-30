//
//  BUserTableViewCell.h
//  Pods
//
//  Created by Benjamin Smiley-andrews on 09/08/2016.
//
//

#import <UIKit/UIKit.h>
#import <ChatSDK/PUser.h>

#define bUserCellRowHeight 50

@interface BUserCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;


-(void) setUser: (id<PUser>) user;

-(void) setSelectedImage;
-(void) setDeSelectedImage;
-(void) setOnline;
-(void) setAway;
-(void) setOffline;
-(void) setAvailabilityLabelText: (NSString *) state;

@end
