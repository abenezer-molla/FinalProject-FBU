////
////  Chat.m
////  Event Locator APP
////
////  Created by abenezermolla on 7/26/21.
////
//
//#import "Chat.h"
//
//@implementation Chat
//
//@dynamic author;
//@dynamic chatPageUsernameP;
//@dynamic chatTitleP;
//@dynamic chatTextLabelP;
//@dynamic chatDateStampP;
//@dynamic likedByUsernameP;
//@dynamic likeRelationP;
//
//+ (nonnull NSString *)parseClassName {
//return @"Chats";
//}
//
//
//+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
//
//    Chat *newPost = [Chat new];
//    newPost.author = [PFUser currentUser];
//    newPost. = caption;
//    newPost.likeCount = @(0);
//    newPost.commentCount = @(0);
//    [newPost saveInBackgroundWithBlock: completion];
//
//}
//
//
//+ (void)like: (Chat *)post withUser:(PFUser *)user withCompletion: (PFBooleanResultBlock) completion {
//    PFRelation *likeRelation = [post relationForKey:@"likeRelation"];
//
//        
//        [likeRelation addObject:user];
//        float likeCount = [post.likeCount doubleValue];
//        post.likeCount = [NSNumber numberWithFloat:likeCount + 1];
//        [post saveInBackgroundWithBlock:completion];
//}
//
//
//+ (void)unlikePost:(Chat *)post withUser:(PFUser *)user withCompletion:(PFBooleanResultBlock)completion {
//    PFRelation *likeRelation = [post relationForKey:@"likeRelation"];
//    [likeRelation removeObject:user];
//    float likeCount = [post.likeCount doubleValue];
//    post.likeCount = [NSNumber numberWithFloat:likeCount - 1];
//    [post saveInBackgroundWithBlock: completion];
//}
//
//
//
//
//@end
