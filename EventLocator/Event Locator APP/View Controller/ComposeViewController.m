//
//  ComposeViewController.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/14/21.
//

#import "ComposeViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "FeedViewController.h"
#import "Post.h"

@interface ComposeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *captionToShare;
@property (weak, nonatomic) IBOutlet UIImageView *imageToShare;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)selectImageAction:(id)sender {    
    
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)shareImageAction:(id)sender {
    
    [Post postUserImage:self.imageToShare.image withCaption:self.captionToShare.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        
        if(succeeded){
            
            NSLog(@"Yay");
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


- (IBAction)canclePostPageAction:(id)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
        // Logging out and swtiching to login view controller
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FeedViewController *feedViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        myDelegate.window.rootViewController = feedViewController;
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
    self.imageToShare.image = [self resizeImage:editedImage withSize:CGSizeMake(300, 300)];
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}
    

@end
