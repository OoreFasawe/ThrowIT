//
//  ThrowerSignUpViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/8/22.
//

#import "ThrowerSignUpViewController.h"
#import <Parse/Parse.h>
#import "Thrower.h"

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
    // Do any additional setup after loading the view.
}
- (IBAction)goToLogin:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.view.window.rootViewController = loginViewController;
}
- (IBAction)registerThrower:(id)sender {
    if([self.throwerNameField.text isEqual:@""] || [self.throwerSchoolField.text isEqual:@""] || [self.throwerEmailField.text isEqual:@""] || [self.throwerPasswordField.text isEqual:@""]){
        //[self showAlert];
    }
    else{
    PFUser *newUser = [PFUser user];
    
    newUser.username = self.throwerNameField.text;
    newUser.password = self.throwerPasswordField.text;
    newUser.email = self.throwerEmailField.text;
    newUser[@"isThrower"] = @YES;
        
    Thrower *partyThrower = [Thrower new];
    partyThrower.throwerName = self.throwerNameField.text;
    partyThrower.school = self.throwerSchoolField.text;
    partyThrower.thrower = newUser;
        
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            
            [Thrower postNewThrower:partyThrower withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                if (error != nil) {
                            NSLog(@"Error: %@", error.localizedDescription);
                }
                else{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UINavigationController *throwerWaitScreenNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ThrowerWaitScreenNavigationController"];
                    self.view.window.rootViewController
                    = throwerWaitScreenNavigationController;
                }
            }];
        }
    }];
}
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