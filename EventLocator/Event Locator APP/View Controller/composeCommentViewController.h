//
//  commentViewController.h
//  Event Locator APP
//
//  Created by abenezermolla on 8/2/21.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface composeCommentViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) Comment *_Nonnull comment;
@property (strong, nonatomic) Post *_Nonnull post;


@end

NS_ASSUME_NONNULL_END
