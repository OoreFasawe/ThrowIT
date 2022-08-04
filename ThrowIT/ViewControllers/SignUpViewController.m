//
//  SignUpViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/5/22.
//

#import "SignUpViewController.h"
#import "Utility.h"
#import <Parse/Parse.h>

@interface SignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)registerUser:(id)sender {
    if([self.usernameField.text isEqual:EMPTY] || [self.passwordField.text isEqual:EMPTY]){
        //TODO: [self showAlert];
    }
    else{
        PFUser *newUser = [PFUser user];
    
        newUser.username = self.usernameField.text;
        newUser.password = self.passwordField.text;
        newUser.email = self.emailField.text;
        newUser[USERISTHROWERKEY] = NOKEYWORD;
    
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
            } 
            else {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN bundle:nil];
                UITabBarController *timelineTabBarController = [storyboard instantiateViewControllerWithIdentifier:TIMELINETABBARCONTROLLER];
                self.view.window.rootViewController = timelineTabBarController;
            }
        }];
    }
}

- (IBAction)goToLogin:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN bundle:nil];
    UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:LOGINVIEWCONTROLLER];
    self.view.window.rootViewController
    = loginViewController;
}

- (IBAction)goToThrowerSignUp:(id)sender {
    UIButton *toThrowerSignUpButton = sender;
    [UIView animateWithDuration:TOSIGNUPSANIMATIONDEFAULTDURATION animations:^{
        toThrowerSignUpButton.layer.zPosition = MAXFLOAT;
        [toThrowerSignUpButton setTitle:EMPTY forState:UIControlStateNormal];
        toThrowerSignUpButton.transform = CGAffineTransformMakeScale(1.f, SIGNUPBARSCALEFACTOR);
    } completion:nil];
    [self performSelector:@selector(transitionToThrowerSignUp) withObject:nil afterDelay: TOSIGNUPSANIMATIONDEFAULTDURATION];
}

-(void)transitionToThrowerSignUp{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN bundle:nil];
    UIViewController *throwerSignUpViewController = [storyboard instantiateViewControllerWithIdentifier:THROWERSIGNUPVIEWCONTROLLER];
    self.view.window.rootViewController = throwerSignUpViewController;
}

- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:true];
}
@end
