//
//  Comment.h
//  Event Locator APP
//
//  Created by abenezermolla on 8/2/21.
//

#import <Parse/Parse.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface Comment : PFObject <PFSubclassing>

@property (nonatomic, strong)  Post *post;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *author;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSMutableArray *commentedByUsername;
@property (nonatomic, strong) PFRelation *commentRelation;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSMutableArray *likedByUsername;
@property (nonatomic, strong) PFRelation *likeRelation;



+ (void) postUserComment:( NSString * _Nullable )text post:(Post *) post withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (void)like: (Comment * _Nullable)chat withUser:(PFUser * _Nullable)user withCompletion: (PFBooleanResultBlock) completion;

+ (void)unlikePost:(Comment * _Nullable)chat withUser:(PFUser * _Nullable)user withCompletion:(PFBooleanResultBlock) completion;

@end

NS_ASSUME_NONNULL_END
