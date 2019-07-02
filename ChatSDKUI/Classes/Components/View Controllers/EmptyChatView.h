//
//  EmptyChatView.h
//  ChatSDK-ChatUI
//
//  Created by Kiran Thakur on 28/06/19.
//

#import <UIKit/UIKit.h>


@interface EmptyChatView : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *emptyViewImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

-(void)setText: (NSString *) title setSubTitle: (NSString *) subtitle setEmptyImage: (UIImage*) image;

@end

