//
//  FeedCell.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/13/21.
//


@import Parse;
#import <ChameleonFramework/Chameleon.h>

#import <Foundation/Foundation.h>
#import "FeedCell.h"

@implementation FeedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.feedcell.backgroundColor = FlatGreen;
    self.typeComment.layer.cornerRadius = 40;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setPost:(Post *)post {
    
    //NSLog(@"%@", post.imageProfile);
    self.feedProfileImage.file = post.imageProfile;
    self.feedPostImage.file = post.image;
    
    [self.feedPostImage loadInBackground];
    [self.feedProfileImage loadInBackground];
    self.feedCaption.text = post.caption;
    self.likeCountFeed.text = post.likeCount.stringValue;
    
    PFUser *user = post.author;
    self.feedUsername.text = user.username;
    self.profileUsername.text = user.username;
    
    self.feedDateStamp.text = [NSDateFormatter localizedStringFromDate:post.createdAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    

}

@end
