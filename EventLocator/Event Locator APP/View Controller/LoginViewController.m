//
//  LoginViewController.m
//  Event Locator APP
//
//  Created by abenezermolla on 7/13/21.
//



#import "LoginViewController.h"
#import <ChameleonFramework/Chameleon.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Parse/Parse.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameLogin;
@property (weak, nonatomic) IBOutlet UITextField *passwordLogin;

@property(weak, nonatomic) NSArray *colors;

@end

@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RandomFlatColor;
    
    RandomFlatColorWithShade(UIShadeStyleLight);
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    //Place the button in the center of my view.
    loginButton.center = self.view.center;
    loginButton.delegate = self;
    [self.view addSubview:loginButton];
    loginButton.permissions = @[@"public_profile", @"email"];

}

- (IBAction)loginTapped:(id)sender {
    [self loginUser];
        
}

- (IBAction)tapGesture:(id)sender {
    
    [self.view endEditing:true];
}


- (IBAction)signupTapped:(id)sender {
    
    if([self.usernameLogin.text isEqual:@""] || [self.passwordLogin.text isEqual:@""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Fill out all the fields to continue."
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                         }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }else{
        [self registerUser];
        self.usernameLogin.text = @"";
        self.passwordLogin.text = @"";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Welcome!"
                                                                       message:@"Sign up complete."
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                         }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
    
    
}


- (void)registerUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    // set user properties
    newUser.username = self.usernameLogin.text;
    //newUser.email = self.usernameField.text;
    newUser.password = self.passwordLogin.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            // manually segue to logged in view
        }
    }];
}


- (void)loginUser {
    NSString *username = self.usernameLogin.text;
    NSString *password = self.passwordLogin.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            
            // display view controller that needs to shown after successful login
        }
    }];
}


- (void)loginButton:(nonnull FBSDKLoginButton *)loginButton didCompleteWithResult:(nullable FBSDKLoginManagerLoginResult *)result error:(nullable NSError *)error {
    if (error != nil) {
        NSLog(@"User log in failed: %@", error.localizedDescription);
    } else {
        NSLog(@"User logged in successfully");
        [self performSegueWithIdentifier:@"loginSegue" sender:nil];
    }
    
}

- (void)loginButtonDidLogOut:(nonnull FBSDKLoginButton *)loginButton {
    
}

@end

