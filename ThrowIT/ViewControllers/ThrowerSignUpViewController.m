//
//  ThrowerSignUpViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/8/22.
//

#import "ThrowerSignUpViewController.h"
#import <Parse/Parse.h>
#import "Thrower.h"
#import "Utility.h"

@interface ThrowerSignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *throwerNameField;
@property (strong, nonatomic) IBOutlet UITextField *throwerSchoolField;
@property (strong, nonatomic) IBOutlet UITextField *throwerEmailField;
@property (strong, nonatomic) IBOutlet UITextField *throwerPasswordField;
@property (strong, nonatomic) NSArray *duplicateThrowerList;

@end

@implementation ThrowerSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)goToLogin:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN bundle:nil];
    UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:LOGINVIEWCONTROLLER];
    self.view.window.rootViewController = loginViewController;
}
- (IBAction)goToUserSignUp:(id)sender {
    UIButton *toThrowerSignUpButton = sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        toThrowerSignUpButton.layer.zPosition = MAXFLOAT;
        [toThrowerSignUpButton setTitle:EMPTY forState:UIControlStateNormal];
        toThrowerSignUpButton.transform = CGAffineTransformMakeScale(1.f, 25.f);
    } completion:nil];
    
    [self performSelector:@selector(transitionToUserSignUp) withObject:nil afterDelay: 0.5];
}

-(void)transitionToUserSignUp{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN bundle:nil];
    UIViewController *signUpViewController = [storyboard instantiateViewControllerWithIdentifier:SIGNUPVIEWCONTROLLER];
    self.view.window.rootViewController
    = signUpViewController;
}

- (IBAction)registerThrower:(id)sender {
    if([self.throwerNameField.text isEqual:EMPTY] || [self.throwerSchoolField.text isEqual:EMPTY] || [self.throwerEmailField.text isEqual:EMPTY] || [self.throwerPasswordField.text isEqual:@""]){
        //TODO: [self showAlert];
    }
    else{
    PFUser *newUser = [PFUser user];
    newUser.username = self.throwerNameField.text;
    newUser.password = self.throwerPasswordField.text;
    newUser.email = self.throwerEmailField.text;
    newUser[USERISTHROWERKEY] = @YES;
    newUser[PARTIESATTENDEDKEY] = ZERO;
    Thrower *partyThrower = [Thrower new];
    partyThrower.throwerName = self.throwerNameField.text;
    partyThrower.school = self.throwerSchoolField.text;
    partyThrower.thrower = newUser;
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        else {
            [Thrower postNewThrower:partyThrower withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (error != nil) {
                            NSLog(@"Error: %@", error.localizedDescription);
                }
                else{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN bundle:nil];
                    UINavigationController *throwerWaitScreenNavigationController = [storyboard instantiateViewControllerWithIdentifier:THROWERWAITSCREENNAVIGATIONCONTROLLER];
                    self.view.window.rootViewController = throwerWaitScreenNavigationController;
                    }
                }];
            }
        }];
    }
}
- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:true];
}

@end
