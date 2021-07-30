//
//  Chat.h
//  Event Locator APP
//
//  Created by abenezermolla on 7/30/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Chat : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSMutableArray *likedByUsername;
@property (nonatomic, strong) PFRelation *likeRelation;

+ (void)like: (Chat * _Nullable)chat withUser:(PFUser * _Nullable)user withCompletion: (PFBooleanResultBlock) completion;

+ (void)unlikePost:(Chat * _Nullable)chat withUser:(PFUser * _Nullable)user withCompletion:(PFBooleanResultBlock) completion;

@end

NS_ASSUME_NONNULL_END
