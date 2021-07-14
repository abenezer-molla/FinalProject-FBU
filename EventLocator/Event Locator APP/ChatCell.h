//
//  ChatCell.h
//  Event Locator APP
//
//  Created by abenezermolla on 7/13/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chatPageUsername;
@property (weak, nonatomic) IBOutlet UILabel *chatTitle;
@property (weak, nonatomic) IBOutlet UILabel *chatTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *chatDateStamp;

@end

NS_ASSUME_NONNULL_END
