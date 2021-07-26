//
//  Comment.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/21/21.
//

#import "Comment.h"

@implementation Comment
@dynamic author;
@dynamic eachComment;

+ (nonnull NSString *)parseClassName {
return @"Comments";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )eachComment withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    Comment *newComment = [Comment new];

    newComment.author = [PFUser currentUser];
    newComment.eachComment = eachComment;

    [newComment saveInBackgroundWithBlock: completion];

}

@end
