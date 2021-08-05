//
//  Comment.m
//  Event Locator APP
//
//  Created by abenezermolla on 8/2/21.
//

#import "Comment.h"

@implementation Comment

@dynamic post;
@dynamic userID;
@dynamic author;
@dynamic comment;
@dynamic commentCount;
@dynamic likeCount;
@dynamic likedByUsername;
@dynamic likeRelation;
@dynamic commentedByUsername;
@dynamic commentRelation;

+ (nonnull NSString *)parseClassName {
return @"Comments";
}

+ (void) postUserComment:( NSString * _Nullable )text post:(Post *) post withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    Comment *newComment = [Comment new];
    newComment.commentCount = @(0);
    newComment.likeCount = @(0);
    newComment.post = post;
    newComment.comment = text;
    [newComment saveInBackgroundWithBlock: completion];

}


+ (void)like: (Comment *)chat withUser:(PFUser *)user withCompletion: (PFBooleanResultBlock) completion {
    PFRelation *likeRelation = [chat relationForKey:@"likeRelation"];
    
        [likeRelation addObject:user];
        float likeCount = [chat.likeCount doubleValue];
        chat.likeCount = [NSNumber numberWithFloat:likeCount + 1];
        [chat saveInBackgroundWithBlock:completion];
}

+ (void)unlikePost:(Comment *)chat withUser:(PFUser *)user withCompletion:(PFBooleanResultBlock)completion {
    
    PFRelation *likeRelation = [chat relationForKey:@"likeRelation"];
    [likeRelation removeObject:user];
    float likeCount = [chat.likeCount doubleValue];
    chat.likeCount = [NSNumber numberWithFloat:likeCount - 1];
    [chat saveInBackgroundWithBlock: completion];
}

@end
