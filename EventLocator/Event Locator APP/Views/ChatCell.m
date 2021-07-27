//
//  ChatCell.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/13/21.
//

#import "ChatCell.h"

#import <Parse/Parse.h>

#import "Post.h"

#import <DateTools/DateTools.h>

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateLikeButton];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


//- (void)setPost:(Chat *)chat {
//
//    _chat = chat;
//    //self.likeCountFeed.text = post.likeCount.stringValue;
//    
//    PFUser *user = chat.author;
//    
//    self.chatTextLabel.text = [@"@" stringByAppendingString:user.username];
//    self.chatPageUsername.text = [@"@" stringByAppendingString:user.username];
//    
//    NSString *const createdAtOriginalString = self.chatDateStamp.text = [NSString stringWithFormat:@"%@", chat.createdAt];
//    NSDateFormatter *const formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss z";
//    NSDate *const date = [formatter dateFromString:createdAtOriginalString];
//    NSDate *const now = [NSDate date];
//    NSInteger timeApart = [now hoursFrom:date];
//    
//    if (timeApart >= 24) {
//        formatter.dateStyle = NSDateFormatterShortStyle;
//        formatter.timeStyle = NSDateFormatterNoStyle;
//        self.chatDateStamp.text = [formatter stringFromDate:date];
//    }
//    else {
//        self.chatDateStamp.text = date.shortTimeAgoSinceNow;
//    }
//    self.likeButtonChat.selected = [self.chat.likedByUsername containsObject:PFUser.currentUser.objectId];
//    
//    [self updateLikeButton];
//    //NSLog(@" end: %@", post);
//    
//}


-(void)updateLikeButton{
    if (self.likeButtonChat.selected == true){
        self.likeButtonChat.tintColor = UIColor.redColor;
        [self.likeButtonChat setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    }else{
        self.likeButtonChat.tintColor = UIColor.labelColor;
        [self.likeButtonChat setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    }
}


- (IBAction)didTapLikeChat:(id)sender {

    if(self.likeButtonChat.selected){
        self.likeButtonChat.selected = false;
        [self.likeButtonChat setSelected:NO];
        [self updateLikeButton];
        
    } else if(!self.likeButtonChat.selected) {
        self.likeButtonChat.selected = true;
        [self.likeButtonChat setSelected:YES];
        [self updateLikeButton];

    }

}


@end
