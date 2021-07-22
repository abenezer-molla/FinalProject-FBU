//
//  ChatViewController.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/13/21.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"

#import "InfinteScrolls.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewChat;
@property (weak, nonatomic) IBOutlet UITextField *composeChatText;
@property (weak, nonatomic) IBOutlet UITextField *chatTitleText;
@property (strong, nonatomic) NSArray *filteredChats;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarLabel;

@property (strong, nonatomic) UIRefreshControl *refreshControl;


@property (strong, nonatomic) NSArray *chats;


@property (nonatomic) BOOL isMoreDataLoading2;
@property (nonatomic) int skipCount2;


@end

@implementation ChatViewController



bool isMoreDataLoading2 = false;
InfinteScrolls* loadingMoreView2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewChat.dataSource = self;
    
    self.tableViewChat.delegate = self;
    self.skipCount2 = 2;
    self.searchBarLabel.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
//
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableViewChat insertSubview:self.refreshControl atIndex:0];
//
    [self refreshData2];
    
    CGRect frame = CGRectMake(0, self.tableViewChat.contentSize.height, self.tableViewChat.bounds.size.width, InfinteScrolls.defaultHeight);
    loadingMoreView2 = [[InfinteScrolls alloc] initWithFrame:frame];
    loadingMoreView2.hidden = true;
    [self.tableViewChat addSubview:loadingMoreView2];
    
    UIEdgeInsets insets = self.tableViewChat.contentInset;
    insets.bottom += InfinteScrolls.defaultHeight;
    self.tableViewChat.contentInset = insets;
    
}


- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    [self refreshData2];


}



- (IBAction)didTapSend:(id)sender {
    
    PFObject *chatMessage = [PFObject objectWithClassName:@"Chats"];
    chatMessage[@"text"] = self.composeChatText.text;
    chatMessage[@"title"] = self.chatTitleText.text;
    
    chatMessage[@"user"] = PFUser.currentUser;
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
    self.composeChatText.text = @"";
    self.chatTitleText.text = @"";
    
    
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSLog(@"Search Bar Called!");
    
    if (searchText.length != 0) {
        
        self.filteredChats = self.chats;

        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@)", searchText];
    
        self.filteredChats = [self.chats filteredArrayUsingPredicate:predicate];
        
        NSLog(@"%@", self.filteredChats);
        
    }
    else {
        self.filteredChats = self.chats;
    }
    
    [self.tableViewChat reloadData];
 
}


- (IBAction)tapGestureChat:(id)sender {
    
    [self.view endEditing:true];
}

- (void)refreshData2{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Chats"];
    [query includeKey:@"user"];
    query.limit = 5;
    [query orderByDescending:@"createdAt"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.chats = posts;
            self.filteredChats = self.chats;
            [self.tableViewChat reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    
    [self.tableViewChat reloadData];
}


- (void)_loadMoreData {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Chats"];
    [query includeKey:@"user"];
    query.limit = 5* self.skipCount2;
    [query orderByDescending:@"createdAt"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.isMoreDataLoading2 = false;
            self.chats = (NSMutableArray*)posts;
            self.filteredChats = self.chats;
            [self.tableViewChat reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    self.skipCount2++;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading2){
        
        //NSLog(@"Posts added to array:  %lu", (unsigned long)self.chats.count);
        
        //NSLog(@"CALLED");
        int scrollViewContentHeight = self.tableViewChat.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableViewChat.bounds.size.height;
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableViewChat.isDragging) {
            self.isMoreDataLoading2 = true;
            
            CGRect frame2 = CGRectMake(0, self.tableViewChat.contentSize.height, self.tableViewChat.bounds.size.width, InfinteScrolls.defaultHeight);
            loadingMoreView2.frame = frame2;
            [loadingMoreView2 startAnimating];
            
            NSTimeInterval delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
              NSLog(@"Do some work");
                [self _loadMoreData];
            });
            
            
        }
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *chatCell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    chatCell.chatTextLabel.text = self.filteredChats[indexPath.row][@"text"];
    chatCell.chatTitle.text = self.filteredChats[indexPath.row][@"title"];
    
    //chatCell.likeCountChat.text = self.chats[indexPath.row][@"likeCount"];
    //chatCell.chatDateStamp.text = [NSDateFormatter localizedStringFromDate:self.chats[indexPath.row][@"createdAt"] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];

    if(self.chats[indexPath.row][@"user"] != nil){
        chatCell.chatPageUsername.text = self.filteredChats[indexPath.row][@"user"][@"username"];
    }else{
        chatCell.chatPageUsername.text = @"Anon";
    }
    
    return chatCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredChats.count;
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
