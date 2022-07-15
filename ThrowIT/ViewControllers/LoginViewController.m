//
//  LoginViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/5/22.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "Thrower.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) NSArray *throwersList;

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
            if (error == nil) {
                //if login is from regular user
                if([user[@"isThrower"] isEqual:@0]){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UITabBarController *timelineTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TimelineTabBarController"];
                self.view.window.rootViewController
                = timelineTabBarController;
                }
                //if login is from thrower
                else{
                    //if thrower is verified
                    PFQuery *query = [PFQuery queryWithClassName:@"Thrower"];
                    [query whereKey:@"thrower" equalTo:user];
                    [query whereKey:@"verified" equalTo:@YES];

                    [query findObjectsInBackgroundWithBlock:^(NSArray  *throwersList, NSError *error) {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        if (throwersList.count){
                            UINavigationController *throwerTimelineNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ThrowerTimelineNavigationController"];
                            self.view.window.rootViewController
                            = throwerTimelineNavigationController;
                        }
                        else{
                            UINavigationController *throwerWaitScreenNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ThrowerWaitScreenNavigationController"];
                            self.view.window.rootViewController
                            = throwerWaitScreenNavigationController;
                        }
                        
                    }];
                }
            }
            else{
                NSLog(@"%@", error.localizedDescription);
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
-(void)checkVerified{
    PFQuery *query = [PFQuery queryWithClassName:@"Thrower"];
    [query whereKey:@"throwerName" equalTo:self.usernameField.text];

    [query findObjectsInBackgroundWithBlock:^(NSArray *throwerList, NSError *error) {
        if(throwerList !=nil){
            self.throwersList = throwerList;
            NSLog(@"%@", throwerList[0][@"verified"]);
        }
        else{
            NSLog(@"Thrower list is nil");
            self.throwersList = nil;
        }
    }];
}
@end
