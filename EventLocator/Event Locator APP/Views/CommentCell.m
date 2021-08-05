//
//  CommentCell.m
//  Event Locator APP
//
//  Created by abenezermolla on 8/2/21.
//
@import Parse;
#import "CommentCell.h"
#import <ChameleonFramework/Chameleon.h>
#import <Foundation/Foundation.h>
#import <DateTools/DateTools.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FeedCell.h"
#import "Comment.h"


@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateLikeButton];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateLikeButton{
    if (self.likeButtonComment.selected == true){
        self.likeButtonComment.tintColor = UIColor.redColor;
        [self.likeButtonComment setImage:[UIImage systemImageNamed:@"heart.fill"] forState:UIControlStateNormal];
    }else{
        self.likeButtonComment.tintColor = UIColor.labelColor;
        [self.likeButtonComment setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    }
}

- (void)setComment:(Comment *)comment {

    _comment = comment;
    self.commentContent.text = comment.comment;
    self.likeCount.text = comment.likeCount.stringValue;
    PFUser *user = comment.author;
    NSLog(@"USERRRRRRR%@", user);
    
    if(comment.author.username){
        self.commentUsername.text = comment.author.username;
    } else{
        self.commentUsername.text = @"Anonymous";
        
        
    }

    
    NSString *const createdAtOriginalString = self.commentDate.text = [NSString stringWithFormat:@"%@", comment.createdAt];
    NSDateFormatter *const formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss z";
    NSDate *const date = [formatter dateFromString:createdAtOriginalString];
    NSDate *const now = [NSDate date];
    NSInteger timeApart = [now hoursFrom:date];
    
    if (timeApart >= 24) {
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        self.commentDate.text = [formatter stringFromDate:date];
    }
    else {
        self.commentDate.text = date.shortTimeAgoSinceNow;
    }
    
    [self updateLikeButton];
}



- (IBAction)didTapLikeComment:(id)sender {
    PFUser * user = [PFUser currentUser];
    if(self.likeButtonComment.selected){
        self.likeButtonComment.selected = false;
        [self.likeButtonComment setSelected:NO];
        [Comment unlikePost:_comment withUser:user withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"Yay");
            } else{
                NSLog(@"Nope");
            }
        }];
        
        [self updateLikeButton];
        
    } else if(!self.likeButtonComment.selected) {
        self.likeButtonComment.selected = true;
        [self.likeButtonComment setSelected:YES];
        [Comment like:_comment withUser:user withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                NSLog(@"Yay");
            } else{
                NSLog(@"Nope");
            }
        }];
        
        [self updateLikeButton];

    }
           
    self.likeCount.text = [NSString stringWithFormat:@"%@", self.comment.likeCount];
    
    
}




@end
