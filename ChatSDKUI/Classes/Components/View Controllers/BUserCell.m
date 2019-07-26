//
//  BUserTableViewCell.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 09/08/2016.
//
//

#import "BUserCell.h"

#import <ChatSDK/UI.h>

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
    [self setAvailabilityLabelText:@""];
    
    [self.profileImageView loadAvatar:user];
    
    [self.profileImageView sd_setImageWithURL:[NSURL URLWithString: user.imageURL]
                             placeholderImage:user.imageAsImage
                                      options:SDWebImageLowPriority & SDWebImageScaleDownLargeImages];
    
    self.title.text = user.name;
    self.subtitle.text = user.statusText;
    
    if (user.availability && user.availability.length && user.online.boolValue) {
        [self setAvailability:user.availability];
    } else {
        if (user.online.boolValue) {
            [self setAvailability:bOnline];
        }
        else {
            [self setAvailability:bOffline];
        }
    }
}

-(void) setAvailabilityLabelText: (NSString *) availability {
    if(!availability || availability.length == 0) {
        [self.statusImageView keepVerticallyCentered];
    }
    else {
        self.statusImageView.keepBottomOffsetTo(self.stateLabel).equal = 5;
    }
    self.stateLabel.text = [NSBundle t:availability];
}

-(void) setAvailability: (NSString *) availability {
    
    if ([availability isEqualToString:bAvailabilityStateChat] || [availability isEqualToString:bAvailabilityStateAvailable]) {
        availability = bOnline;
    }
    self.statusImageView.image = [NSBundle uiImageNamed: [NSString stringWithFormat:@"icn_16_status_%@.png", availability]];
    [self setAvailabilityLabelText:availability];
}

-(void) setOnline {
    self.statusImageView.image = [NSBundle uiImageNamed: @"icn_16_status_online.png"];
}

-(void) setAway {
    self.statusImageView.image = [NSBundle uiImageNamed: @"icn_16_status_away.png"];
}

-(void) setOffline {
    self.statusImageView.image = [NSBundle uiImageNamed: @"icn_16_status_offline.png"];
}


@end
