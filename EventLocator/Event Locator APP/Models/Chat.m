//
//  Chat.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/30/21.
//

#import "Chat.h"

@implementation Chat

@dynamic postID;
@dynamic userID;
@dynamic user;
@dynamic title;
@dynamic text;
@dynamic likeCount;
@dynamic likedByUsername;
@dynamic likeRelation;

+ (nonnull NSString *)parseClassName {
return @"Chats";
}

+ (void)like: (Chat *)chat withUser:(PFUser *)user withCompletion: (PFBooleanResultBlock) completion {
    PFRelation *likeRelation = [chat relationForKey:@"likeRelation"];
    
        [likeRelation addObject:user];
        float likeCount = [chat.likeCount doubleValue];
        chat.likeCount = [NSNumber numberWithFloat:likeCount + 1];
        [chat saveInBackgroundWithBlock:completion];
}

+ (void)unlikePost:(Chat *)chat withUser:(PFUser *)user withCompletion:(PFBooleanResultBlock)completion {
    
    PFRelation *likeRelation = [chat relationForKey:@"likeRelation"];
    [likeRelation removeObject:user];
    float likeCount = [chat.likeCount doubleValue];
    chat.likeCount = [NSNumber numberWithFloat:likeCount - 1];
    [chat saveInBackgroundWithBlock: completion];
}


@end
