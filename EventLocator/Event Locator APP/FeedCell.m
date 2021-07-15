//
//  FeedCell.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/13/21.
//


@import Parse;

#import "FeedCell.h"

@implementation FeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setPost:(Post *)post {
    self.feedProfileImage.file = post.image;
    self.feedPostImage.file = post.image;
    
    [self.feedPostImage loadInBackground];
    self.feedCaption.text = post.caption;
    self.likeCountFeed.text = post.likeCount.stringValue;
    
    PFUser *user = post.author;
    self.feedUsername.text = user.username;
    self.profileUsername.text = user.username;
    
    self.feedDateStamp.text = [NSDateFormatter localizedStringFromDate:post.createdAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    

}

@end
