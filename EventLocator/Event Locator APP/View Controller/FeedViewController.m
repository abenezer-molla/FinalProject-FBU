//
//  FeedViewController.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/13/21.
//

#import <ChameleonFramework/Chameleon.h>

#import <MGSwipeTableCell/MGSwipeTableCell.h>

#import "FeedViewController.h"

#import "AppDelegate.h"

#import "Post.h"

#import "FeedCell.h"

#import "Parse/Parse.h"

#import "SceneDelegate.h"

#import "LoginViewController.h"

#import "InfinteScrolls.h"

#import "Comment.h"

#import "CommentsCell.h"

#import <FBSDKCoreKit/FBSDKProfile.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <FBSDKLoginKit/FBSDKLoginManager.h>

#import <DateTools/DateTools.h>

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *feeds;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL isMoreDataLoading;
@property (nonatomic) int skipCount;
@property (assign, nonatomic) BOOL isDragging;
@property (strong, nonatomic) NSDate *_Nullable dateOfLastLoadedPost;
@property (weak, nonatomic) IBOutlet UIImageView *toSaveTheProfilePic;

@end

@implementation FeedViewController


bool isMoreDataLoading = false;
InfinteScrolls* loadingMoreView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = FlatGray;
    
    RandomFlatColorWithShade(UIShadeStyleLight);
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [FBSDKProfile loadCurrentProfileWithCompletion:^(FBSDKProfile * _Nullable profile, NSError * _Nullable error) {
            if (profile) {
                self.navigationItem.title = [NSString stringWithFormat:@"Hello %@ %@", profile.firstName, profile.lastName];
                NSURL *url = [profile imageURLForPictureMode:(FBSDKProfilePictureModeSquare) size:(CGSizeMake(35, 35))];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                
                UIView *profileView =  [[UIView alloc]initWithFrame:(CGRectMake(0, 0, 35, 35))];
                
                profileView.layer.cornerRadius = profileView.frame.size.width/2;
                profileView.clipsToBounds = YES;
                profileView.userInteractionEnabled = YES;
                
                UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutFromTapGesture)];
                [profileView addGestureRecognizer:gestureRecognizer];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                [profileView addSubview:imageView];
                UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]initWithCustomView:profileView];
                self.navigationItem.leftBarButtonItem = buttonItem;
                
            }
        }];
        
        
    });
    
    
    self.skipCount = 2;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfinteScrolls.defaultHeight);
    loadingMoreView = [[InfinteScrolls alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.tableView addSubview:loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfinteScrolls.defaultHeight;
    self.tableView.contentInset = insets;
    
    [self refreshData];
    
    // Do any additional setup after loading the view.
}


- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    [self refreshData];

}


- (IBAction)didTapSelectProfileButton:(id)sender {
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
   
}

-(void) logoutFromTapGesture{
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    // Logging out and swtiching to login view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;

    
    NSLog(@"LOGOUT TAPPED");
}


- (IBAction)didTapShareProfile:(id)sender {
    [Post postUserProfileImage: self.toSaveTheProfilePic.image withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        
        if(succeeded){
            
            NSLog(@"Yay");
        } else{
            
            NSLog(@"Nope");
        }
    }];
}


- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.toSaveTheProfilePic.image = [self resizeImage:editedImage withSize:CGSizeMake(300, 300)];
    // Do something with the images (based on your use case)
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)refreshData{
    
    Post *newPost = [Post new];
    // get the current user and assign it to "author" field. "author" field is now of Pointer type
    newPost.author = [PFUser currentUser];
    // construct query
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery includeKey:@"caption"];
    [postQuery whereKeyExists:@"caption"];
    postQuery.limit = 3;
    // fetch data asynchronously
    [self.tableView reloadData];

    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            
            self.feeds = posts;
            if (self.feeds.count > 0) {
                self.dateOfLastLoadedPost = ((Post*) posts[posts.count - 1]).createdAt;
            }
            // do something with the data fetched
            self.feeds = (NSMutableArray*)posts;
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            // handle error
            
            NSLog(@"%@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Network"
                                                                                       message:@"Please connect your device to a network source and try again."
                                                                                preferredStyle:(UIAlertControllerStyleAlert)];
            // create a cancel action
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle cancel response here. Doing nothing will dismiss the view.
                                                              }];
            // add the cancel action to the alertController
            [alert addAction:cancelAction];

            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle response here.
                                                             }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        }
    }];
    [self.tableView reloadData];

}


- (IBAction)gestureOnFeedTapped:(id)sender {
    
    [self.view endEditing:true];
}


- (IBAction)didTapComment:(id)sender {
    
    NSLog(@"Commented!");
    
}


- (IBAction)logoutTapped:(id)sender {
   
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
        SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        // Logging out and swtiching to login view controller
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
    
}

- (void)loginButtonDidLogOut:(nonnull FBSDKLoginButton *)loginButton {
    
}

- (void)_loadMoreData {
   
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    //NSDate *now = [NSDate now];
    if (self.dateOfLastLoadedPost != nil) {
        [query whereKey:@"createdAt" lessThan:self.dateOfLastLoadedPost];
    }
    query.limit = 3 * self.skipCount;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query includeKey:@"caption"];
    [query whereKeyExists:@"caption"];
        
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            //NSLog(@"%d",posts.count);
            NSLog(@"Total elements in the array :  %lu", (unsigned long)self.feeds.count);
            self.isMoreDataLoading = false;
            self.feeds = (NSMutableArray *)posts;
            [self.tableView reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Network"
                                                                                       message:@"Please connect your device to a network source and try again."
                                                                                preferredStyle:(UIAlertControllerStyleAlert)];
            // create a cancel action
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancle"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle cancel response here. Doing nothing will dismiss the view.
                                                              }];
            // add the cancel action to the alertController
            [alert addAction:cancelAction];

            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Try Again"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                     // handle response here.
                                                             }];
            // add the OK action to the alert controller
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        }
    }];
    
    self.skipCount++;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){

        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && !self.isDragging) {
            self.isMoreDataLoading = true;
            
            CGRect frame2 = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfinteScrolls.defaultHeight);
            loadingMoreView.frame = frame2;
            [loadingMoreView startAnimating];
            
            NSTimeInterval delayInSeconds = 0.1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

                [self _loadMoreData];
            });
                        
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.isDragging = false;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isDragging = true;
}


#pragma mark - UITableViewDelegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
 
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCell"];
    cell.layer.cornerRadius = 35; // uses external library
    cell.clipsToBounds = true;
    Post *post = self.feeds[indexPath.row];
    [cell setPost:post];
    cell.post = self.feeds[indexPath.row];
    
    return cell;
        
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feeds.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

