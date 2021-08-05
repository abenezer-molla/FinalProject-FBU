
//  CommentCell.h
//  Event Locator APP
//
//  Created by abenezermolla on 8/2/21.
//

@import Parse;
#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Comment.h"


NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *commentUsername;
@property (weak, nonatomic) IBOutlet UILabel *commentDate;
@property (weak, nonatomic) IBOutlet UILabel *commentContent;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *likeButtonComment;


@property (strong, nonatomic) CommentCell *commentcell;
@property (strong, nonatomic) Comment *comment;

@end

NS_ASSUME_NONNULL_END
