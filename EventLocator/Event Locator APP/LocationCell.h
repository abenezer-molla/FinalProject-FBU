//
//  LocationCell.h
//  Event Locator APP
//
//  Created by abenezermolla on 7/15/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationCell : UITableViewCell



- (void)updateWithLocation:(NSDictionary *)location;

@end

NS_ASSUME_NONNULL_END
