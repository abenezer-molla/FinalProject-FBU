//
//  Post.h
//  Event Locator APP
//
//  Created by abenezermolla on 7/14/21.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : PFObject <PFSubclassing>

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) PFFileObject *imageProfile;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSMutableArray *likedByUsername;

@property (nonatomic, strong) PFRelation *likeRelation;

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void) postUserProfileImage: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void)like: (Post * _Nullable)post withUser:(PFUser * _Nullable)user withCompletion: (PFBooleanResultBlock) completion;

+ (void)unlikePost:(Post * _Nullable)post withUser:(PFUser * _Nullable)user withCompletion:(PFBooleanResultBlock) completion;

//+ (Post*_Nonnull) likePost:(Post*_Nonnull)post;

@end

NS_ASSUME_NONNULL_END
