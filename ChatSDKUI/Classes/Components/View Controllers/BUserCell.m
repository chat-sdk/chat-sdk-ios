//
//  BUserTableViewCell.m
//  Pods
//
//  Created by Benjamin Smiley-andrews on 09/08/2016.
//
//

#import "BUserCell.h"
#import <ChatSDK/PUser.h>
#import <ChatSDK/UI.h>

@implementation BUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.profileImageView.layer.cornerRadius = self.profileImageView.fh/2.0;
    self.profileImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.profileImageView.layer.borderWidth = 1.0;
    self.profileImageView.clipsToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void) setUser: (id<PUser>) user {
  //  _statusImageView.image = 
    // TODO: Don't use absolute value
   // self.profileImageView.layer.cornerRadius = 22;
   // self.profileImageView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone; // If we don't set this then sometimes the cells don't refresh properly
    
    //self.profileImageView.layer.borderWidth = 2;
    self.statusImageView.layer.cornerRadius = 6;
    [self setAvailabilityLabelText:@""];
    
    [self.profileImageView loadAvatar:user];
    
    self.title.text = user.name;
//    self.subtitle.text = user.statusText;
//
//    if (user.availability) {
//        [self setAvailabilityLabelText:user.availability];
//    } else {
//        if (user.online.boolValue) {
//            [self setAvailabilityLabelText:[NSBundle t: NSLocalizedString(bOnline, nil)]];
//        }
//        else {
//            [self setAvailabilityLabelText:[NSBundle t: bOffline]];
//        }
//    }
//
//    if (user.availability && user.availability.length && user.online.boolValue && ![user.availability isEqualToString:bAvailabilityStateChat]) {
//        [self setAway];
//    } else {
//        if (user.online.boolValue) {
//            [self setOnline];
//        }
//        else {
//            [self setOffline];
//        }
//    }
    
    self.subtitle.text = @"";
    self.statusImageView.hidden = false;

    BOOL value = [[user.meta metaValueForKey:@"can_message"] boolValue];
    if (value == false){
        self.statusImageView.image = [NSBundle uiImageNamed:@"checkbox_disabeled@2x.png"];
        self.subtitle.text = [NSBundle t: NSLocalizedString(@"application_not_installed", nil)];
    }
//    printf("%@", [user.meta metaStringForKey:@"can_message"]);
//    if ([user.meta metaValueForKey:@"can_message"] == true) {
//        self.subtitle.text = @"Available";
//    }
//    else{
//        self.subtitle.text = @"Not Available";
//    }
//    if ((NSNumber*)[user.meta metaValueForKey:@"can_message"] == 1) {
//        self.subtitle.text = @"Available";
//    }
//    else{
//        self.subtitle.text = @"Not Available";
//    }
    

    
   // self.subtitle.text = user.statusText;

//    if (user.online.boolValue) {
//        [self setOnline];
//    }
//    else {
//        [self setOffline];
//    }
}



-(void) setAvailabilityLabelText: (NSString *) availability {
    if(!availability || availability.length == 0) {
        [self.statusImageView keepVerticallyCentered];
    }
    else {
        self.statusImageView.keepBottomOffsetTo(self.stateLabel).equal = 5;
//        self.statusImageView.keepVerticalAlignTo(self.statusImageView.superview).equal = -15;
    }
    self.stateLabel.text = [NSBundle t:availability];
}

-(void) setSelectedImage {
    self.statusImageView.image = [NSBundle uiImageNamed: @"checkBox@2x"];
}

-(void) setDeSelectedImage {
    self.statusImageView.image = [NSBundle uiImageNamed: @"empty_checkBox@2x.png"];
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
