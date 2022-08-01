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
#import "Utility.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) NSArray *throwersList;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)loginUser:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if([self.usernameField.text isEqual:EMPTY] || [self.passwordField.text isEqual:EMPTY]){
       // TODO: [self showAlert];
    }
    else{
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
            if (error == nil) {
                //if login is from regular user
                if([user[USERISTHROWERKEY] isEqual:@0]){
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN bundle:nil];
                UITabBarController *timelineTabBarController = [storyboard instantiateViewControllerWithIdentifier:TIMELINETABBARCONTROLLER];
                self.view.window.rootViewController
                = timelineTabBarController;
                }
                //if login is from thrower
                else{
                    //if thrower is verified
                    PFQuery *query = [PFQuery queryWithClassName:THROWERCLASS];
                    [query whereKey:THROWERKEY equalTo:user];
                    [query whereKey:VERIFIEDKEY equalTo:@YES];

                    [query findObjectsInBackgroundWithBlock:^(NSArray  *throwersList, NSError *error) {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN bundle:nil];
                        if (throwersList.count){
                            UINavigationController *throwerTimelineTabBarController = [storyboard instantiateViewControllerWithIdentifier:THROWERTIMELINETABBARCONTROLLER];
                            self.view.window.rootViewController
                            = throwerTimelineTabBarController;
                        }
                        else{
                            UINavigationController *throwerWaitScreenNavigationController = [storyboard instantiateViewControllerWithIdentifier:THROWERWAITSCREENNAVIGATIONCONTROLLER];
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN bundle:nil];
    UIViewController *signUpViewController = [storyboard instantiateViewControllerWithIdentifier:SIGNUPVIEWCONTROLLER];
    
    self.view.window.rootViewController
    = signUpViewController;
}

-(void)checkVerified{
    PFQuery *query = [PFQuery queryWithClassName:THROWERCLASS];
    [query whereKey:THROWERNAMEKEY equalTo:self.usernameField.text];

    [query findObjectsInBackgroundWithBlock:^(NSArray *throwerList, NSError *error) {
        if(throwerList !=nil){
            self.throwersList = throwerList;
        }
        else{
            self.throwersList = nil;
        }
    }];
}
- (IBAction)onTapView:(id)sender {
    [self.view endEditing:true];
}
@end
