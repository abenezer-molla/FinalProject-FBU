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
