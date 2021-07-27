//
//  Post.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/14/21.
//

#import "Post.h"

@implementation Post



@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;
@dynamic likedByUsername;
@dynamic imageProfile;
@dynamic likeRelation;

+ (nonnull NSString *)parseClassName {
return @"Post";
}

+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);

    [newPost saveInBackgroundWithBlock: completion];

}

+ (void) postUserProfileImage: ( UIImage * _Nullable )image withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    Post *newPost2 = [Post new];
    newPost2.imageProfile = [self getPFFileFromImage:image];
    [newPost2 saveInBackgroundWithBlock: completion];

}



+ (void)like: (Post *)post withUser:(PFUser *)user withCompletion: (PFBooleanResultBlock) completion {
    PFRelation *likeRelation = [post relationForKey:@"likeRelation"];

        
        [likeRelation addObject:user];
    NSLog(@"Like Method Called!%@", user);
        float likeCount = [post.likeCount doubleValue];
        post.likeCount = [NSNumber numberWithFloat:likeCount + 1];
        [post saveInBackgroundWithBlock:completion];
}


+ (void)unlikePost:(Post *)post withUser:(PFUser *)user withCompletion:(PFBooleanResultBlock)completion {
    PFRelation *likeRelation = [post relationForKey:@"likeRelation"];
    [likeRelation removeObject:user];
    float likeCount = [post.likeCount doubleValue];
    post.likeCount = [NSNumber numberWithFloat:likeCount - 1];
    [post saveInBackgroundWithBlock: completion];
}


+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)newImage {
    // check if image is not nil
    if (!newImage) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(newImage);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFileObject fileObjectWithName:(@"image.png") data:imageData];
}

@end







