//
//  commentViewController.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/21/21.
//


@import Parse;

#import "Parse/Parse.h"
#import "commentViewController.h"

#import "CommentsCell.h"

#import "Post.h"

@interface commentViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *comments;

@end

@implementation commentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    
   self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.commentTableView insertSubview:self.refreshControl atIndex:0];
//
    [self refreshData3];
    // Do any additional setup after loading the view.
}


- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self refreshData3];
}


- (void)refreshData3{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Comments"];
    [query includeKey:@"user"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.comments = posts;
            [self.commentTableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
    [self.commentTableView reloadData];
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CommentsCell *commentCell = [tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
//    commentCell.comments.text = self.comments[indexPath.row][@"text"];
//    commentCell.commentsUsername.text = self.comments[indexPath.row][@"title"];
//
//    //chatCell.likeCountChat.text = self.chats[indexPath.row][@"likeCount"];
//    //chatCell.chatDateStamp.text = [NSDateFormatter localizedStringFromDate:self.chats[indexPath.row][@"createdAt"] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
//
//    if(self.comments[indexPath.row][@"user"] != nil){
//        commentCell.commentsUsername.text = self.comments[indexPath.row][@"user"][@"username"];
//    }else{
//        commentCell.commentsUsername.text = @"Anon";
//    }
    
    return commentCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.comments.count;
    
    return 10;
}










/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)typeComment:(id)sender {
}
@end
