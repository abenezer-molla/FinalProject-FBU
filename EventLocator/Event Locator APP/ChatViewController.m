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

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableViewChat;
@property (weak, nonatomic) IBOutlet UITextField *composeChatText;

@property (strong, nonatomic) NSArray *chats;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewChat.dataSource = self;
    
    self.tableViewChat.delegate = self;
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshData) userInfo:nil repeats:true];
    
    
    // Do any additional setup after loading the view.
}




- (IBAction)didTapSend:(id)sender {
    
    PFObject *chatMessage = [PFObject objectWithClassName:@"Post"];
    chatMessage[@"text"] = self.composeChatText.text;
    chatMessage[@"user"] = PFUser.currentUser;
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
    self.composeChatText.text = @"";
    
    
    
}

- (void)refreshData{
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Message_FBU2021"];
    [query includeKey:@"user"];
    query.limit = 20;
    [query orderByDescending:@"createdAt"];
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.chats = posts;
            [self.tableViewChat reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ChatCell *chatCell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    chatCell.chatTextLabel.text = self.chats[indexPath.row][@"text"];
    if(self.chats[indexPath.row][@"user"] != nil){
        chatCell.chatPageUsername.text = self.chats[indexPath.row][@"user"][@"username"];
    }else{
        chatCell.chatPageUsername.text = @"Anon";
    }
    
    return chatCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chats.count;
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
