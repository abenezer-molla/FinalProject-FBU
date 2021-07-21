//
//  InfinteScrolls.h
//  Event Locator APP
//
//  Created by abenezermolla on 7/20/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InfinteScrolls : UIView

@property (class, nonatomic, readonly) CGFloat defaultHeight;

- (void)startAnimating;
- (void)stopAnimating;


@end

NS_ASSUME_NONNULL_END
