//
//  BUserTableViewCell.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 09/08/2016.
//
//

#import "BUserCell.h"

#import <ChatSDKUI/ChatUI.h>

@implementation BUserCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) setUser: (id<PUser>) user {
    
    // TODO: Don't use absolute value
    self.profileImageView.layer.cornerRadius = 22;
    self.profileImageView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone; // If we don't set this then sometimes the cells don't refresh properly
    
    //self.profileImageView.layer.borderWidth = 2;
    self.statusImageView.layer.cornerRadius = 6;
    self.stateLabel.text = @"";

    if (user.thumbnail) {
        self.profileImageView.image = [UIImage imageWithData:user.thumbnail];
    }
    else {
        self.profileImageView.image = user.defaultImage;
    }
    
    self.title.text = user.name;
    self.subtitle.text = user.statusText;
    
    if (user.online.boolValue) {
        [self setOnline];
    }
    else {
        [self setOffline];
    }
}

-(void) setOnline {
    self.statusImageView.image = [NSBundle chatUIImageNamed: @"icn_16_status_online.png"];
}

-(void) setAway {
    self.statusImageView.image = [NSBundle chatUIImageNamed: @"icn_16_status_away.png"];
}

-(void) setOffline {
    self.statusImageView.image = [NSBundle chatUIImageNamed: @"icn_16_status_offline.png"];
}


@end
