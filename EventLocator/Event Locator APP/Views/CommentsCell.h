//
//  CommentsCell.h
//  Event Locator APP
//
//  Created by abenezermolla on 7/21/21.
//

#import <UIKit/UIKit.h>

#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommentsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentsUsername;
@property (weak, nonatomic) IBOutlet UILabel *comments;


@property (strong, nonatomic)  Comment *commentP;

@end

NS_ASSUME_NONNULL_END
