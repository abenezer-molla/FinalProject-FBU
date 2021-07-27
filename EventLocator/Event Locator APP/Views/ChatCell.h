//
//  ChatCell.h
//  Event Locator APP
//
//  Created by abenezermolla on 7/13/21.
//

#import <UIKit/UIKit.h>
#import "Chat.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chatPageUsername;
@property (weak, nonatomic) IBOutlet UILabel *chatTitle;
@property (weak, nonatomic) IBOutlet UILabel *chatTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatDateStamp;
@property (weak, nonatomic) IBOutlet UILabel *likeCountChat;
@property (weak, nonatomic) IBOutlet UIButton *likeButtonChat;


@end

NS_ASSUME_NONNULL_END
