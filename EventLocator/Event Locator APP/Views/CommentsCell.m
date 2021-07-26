//
//  CommentsCell.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/21/21.
//

#import "CommentsCell.h"

@implementation CommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}



- (void)setPost:(Comment *)comment {
    self.comments.text = comment.eachComment;
    self.commentsUsername.text = comment.author.username;

}

@end
