//
//  Comment.h
//  Event Locator APP
//
//  Created by abenezermolla on 7/21/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Comment : PFObject <PFSubclassing>
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *eachComment;


@end




NS_ASSUME_NONNULL_END
