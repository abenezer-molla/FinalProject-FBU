//
//  FeedViewController.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/13/21.
//

#import "FeedViewController.h"

#import "AppDelegate.h"

#import "FeedCell.h"

#import "Parse/Parse.h"

#import "SceneDelegate.h"

#import "LoginViewController.h"

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *feeds;
@property (strong, nonatomic) UIRefreshControl *refreshControl;




@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Do any additional setup after loading the view.
}


- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    [self refreshData];


}



- (void)refreshData{
    
    Post *newPost = [Post new];

    // get the current user and assign it to "author" field. "author" field is now of Pointer type
    newPost.author = [PFUser currentUser];
        
    // construct query
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;

    // fetch data asynchronously
    [self.tableView reloadData];
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
                        self.feeds = posts;
                        [self.tableView reloadData];
                        [self.refreshControl endRefreshing];
        }
        else {
            // handle error
            
                        NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.tableView reloadData];

}




- (IBAction)logoutTapped:(id)sender {
    
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
//    [self dismissViewControllerAnimated:YES completion:nil];
        SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        // Logging out and swtiching to login view controller
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
    
    
    Post *post = self.feeds[indexPath.row];
    NSLog(@"%@", post);
    [cell setPost:post];
    
    return cell;
    
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.feeds.count;
    
}

@end

