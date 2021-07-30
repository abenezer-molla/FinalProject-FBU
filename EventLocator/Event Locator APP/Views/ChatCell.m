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

- (void)setChat:(Chat *)chat {

    _chat = chat;
    
    self.chatTextLabel.text = chat.text;
    self.chatTitle.text = chat.title;
    self.likeCountChat.text = chat.likeCount.stringValue;
    PFUser *user = chat.user;
    self.chatPageUsername.text = [@"@" stringByAppendingString:user.username];
    
    NSString *const createdAtOriginalString = self.chatDateStamp.text = [NSString stringWithFormat:@"%@", chat.createdAt];
    NSDateFormatter *const formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss z";
    NSDate *const date = [formatter dateFromString:createdAtOriginalString];
    NSDate *const now = [NSDate date];
    NSInteger timeApart = [now hoursFrom:date];
    
    if (timeApart >= 24) {
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        self.chatDateStamp.text = [formatter stringFromDate:date];
    }
    else {
        self.chatDateStamp.text = date.shortTimeAgoSinceNow;
    }
    self.likeButtonChat.selected = [self.chat.likedByUsername containsObject:PFUser.currentUser.objectId];
    
    [self updateLikeButton];
}

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

    PFUser * user = [PFUser currentUser];
    if(self.likeButtonChat.selected){
        self.likeButtonChat.selected = false;
        [self.likeButtonChat setSelected:NO];
        [Chat unlikePost:_chat withUser:user withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"Yay");
            } else{
                NSLog(@"Nope");
            }
        }];
        
        [self updateLikeButton];
        
    } else if(!self.likeButtonChat.selected) {
        self.likeButtonChat.selected = true;
        [self.likeButtonChat setSelected:YES];
        [Chat like:_chat withUser:user withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"Yay");
            } else{
                NSLog(@"Nope");
            }
        }];
        
        [self updateLikeButton];

    }
           
    self.likeCountChat.text = [NSString stringWithFormat:@"%@", self.chat.likeCount];

}


@end
