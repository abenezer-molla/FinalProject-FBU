//
//  commentViewController.m
//  Event Locator APP
//
//  Created by abenezermolla on 8/2/21.
//

#import <ChameleonFramework/Chameleon.h>
#import "composeCommentViewController.h"
#import "SceneDelegate.h"
#import "FeedViewController.h"
#import "Parse/Parse.h"
#import "Comment.h"
#import "CommentCell.h"
@interface composeCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *commentToShare;
@property (strong, nonatomic) NSMutableArray *_Nullable comments;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@end

@implementation composeCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentTableView.backgroundColor = FlatGray;
    // Do any additional setup after loading the view.
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    [self fetchComments];

}

- (void)fetchComments {
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    NSLog(@" the comment's object ID is%@", self.comment.objectId);
    [query whereKey:@"post" equalTo:self.post];
    [query includeKey:@"author"];
    [query includeKey:@"post"];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *_Nullable comments, NSError *_Nullable error){
        if (!error) {
            self.comments = comments;
            NSLog(@"%@", self.comments);
        }
        [self.commentTableView reloadData];
    }];
}



- (IBAction)cancleComment:(id)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        // Logging out and swtiching to login view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FeedViewController *feedViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        myDelegate.window.rootViewController = feedViewController;
}


- (IBAction)didTapSendComment:(id)sender {

    if(!self.post){
        return;
    }
    [Comment postUserComment:self.commentToShare.text post:self.post withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        
        if(succeeded){
            
            NSLog(@"Yay Comment Saved");
        } else{
            
            NSLog(@"Nope");
        }
    }];
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        // Logging out and swtiching to login view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FeedViewController *feedViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        myDelegate.window.rootViewController = feedViewController;
    
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    cell.layer.cornerRadius = 35; // uses external library
    cell.clipsToBounds = true;
    Comment *comment= self.comments[indexPath.row];
    [cell setComment:comment];
    cell.comment = self.comments[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}



@end
