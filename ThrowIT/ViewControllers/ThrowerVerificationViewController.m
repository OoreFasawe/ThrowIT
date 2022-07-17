//
//  ThrowerVerificationViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/11/22.
//

#import "ThrowerVerificationViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"

@interface ThrowerVerificationViewController ()

@end

@implementation ThrowerVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)logoutUser:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (!error)
        {
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            sceneDelegate.window.rootViewController = loginViewController;
        }
    }];
}
@end
