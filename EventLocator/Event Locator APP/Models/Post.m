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

+ (Post*) likePost:(Post*)post{
    if (post.likedByUsername == nil){
        post.likedByUsername = [[NSArray alloc]init];
    }

    [post.likedByUsername addObject:PFUser.currentUser.objectId];
    [post setObject:post.likedByUsername forKey:@"likedByUsername"];
    [post saveInBackground];
    
    NSLog(@"Liked");

    return post;
}

- (void)like {
    [self.likedByUsername addObject:PFUser.currentUser.objectId];
    [self addObject:self.likedByUsername forKey:@"likedByUsername"];
    [self saveInBackground];
}


- (void)unlike {
    [self.likedByUsername removeObject:PFUser.currentUser.objectId];
    [self addObject:self.likedByUsername forKey:@"likedByUsername"];
    [self saveInBackground];
    NSLog(@"Liked");
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







