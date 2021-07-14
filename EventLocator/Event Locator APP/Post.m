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







