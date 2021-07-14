//
//  FeedCell.h
//  Event Locator APP
//
//  Created by abenezermolla on 7/13/21.
//


@import Parse;
#import <UIKit/UIKit.h>

#import "Post.h"

#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface FeedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *profileUsername;
@property (weak, nonatomic) IBOutlet UILabel *feedUsername;
@property (weak, nonatomic) IBOutlet PFImageView *feedPostImage;

@property (weak, nonatomic) IBOutlet PFImageView *feedProfileImage;

@property (weak, nonatomic) IBOutlet UILabel *feedCaption;

@property (weak, nonatomic) IBOutlet UILabel *feedDateStamp;



@property (strong, nonatomic) Post *post;

@end



NS_ASSUME_NONNULL_END
