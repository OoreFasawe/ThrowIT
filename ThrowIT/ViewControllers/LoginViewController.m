//
//  LoginViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/5/22.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)loginUser:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
if([self.usernameField.text isEqual:@""] || [self.passwordField.text isEqual:@""]){
   // [self showAlert];
    
}
else{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *timelineTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TimelineTabBarController"];
            self.view.window.rootViewController
            = timelineTabBarController;         
        }
    }];
}
}
- (IBAction)goToSignUp:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *signUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    
    self.view.window.rootViewController
    = signUpViewController;
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
