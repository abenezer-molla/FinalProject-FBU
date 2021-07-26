//
//  FeedCell.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/13/21.
//


@import Parse;
#import <ChameleonFramework/Chameleon.h>

#import <Foundation/Foundation.h>
#import <DateTools/DateTools.h>
#import "FeedCell.h"
#import "Post.h"

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

    self.feedPostImage.file = post.image;
    self.feedProfileImage.file = post.image;
    self.feedProfileImage.clipsToBounds = YES;
    self.feedPostImage.layer.cornerRadius = self.feedPostImage.frame.size.width / 5;
    self.feedPostImage.clipsToBounds = YES;
    [self.feedPostImage loadInBackground];
    [self.feedProfileImage loadInBackground];
    self.feedCaption.text = post.caption;
    self.likeCountFeed.text = post.likeCount.stringValue;
    
    PFUser *user = post.author;
    
    self.feedUsername.text = [@"@" stringByAppendingString:user.username];
    self.profileUsername.text = [@"@" stringByAppendingString:user.username];
    
    NSString *const createdAtOriginalString = self.feedDateStamp.text = [NSString stringWithFormat:@"%@", post.createdAt];
    NSDateFormatter *const formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss z";
    NSDate *const date = [formatter dateFromString:createdAtOriginalString];
    NSDate *const now = [NSDate date];
    NSInteger timeApart = [now hoursFrom:date];
    
    if (timeApart >= 24) {
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        self.feedDateStamp.text = [formatter stringFromDate:date];
    }
    else {
        self.feedDateStamp.text = date.shortTimeAgoSinceNow;
    }
    self.likeButton.selected = [self.post.likedByUsername containsObject:PFUser.currentUser.objectId];
    [self updateLikeButton];
    
}

-(void)updateLikeButton{
    if ([self.post.likedByUsername containsObject: PFUser.currentUser.objectId]){
        self.likeButton.tintColor = UIColor.redColor;
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    }else{
        self.likeButton.tintColor = UIColor.labelColor;
        [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    }
}

- (IBAction)didTapLikeButton:(id)sender {
    
    if(self.likeButton.selected){
        self.likeButton.selected = false;
        [self.likeButton setSelected:NO];
        self.post.likeCount = [NSNumber numberWithInteger:([self.post.likeCount intValue] - 1)];
        [self.post unlike];
        
    } else if(!self.likeButton.selected) {
        self.likeButton.selected = true;
        [self.likeButton setSelected:YES];
        self.post.likeCount = [NSNumber numberWithInteger:([self.post.likeCount intValue] + 1)];
        if(!self.post.likedByUsername) {
            self.post.likedByUsername = [NSMutableArray new];
        }
        [self.post like];
        [self updateLikeButton];

    }
    self.likeCountFeed.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
}


@end
