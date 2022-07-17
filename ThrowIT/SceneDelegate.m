//
//  SceneDelegate.m
//  ThrowIT
//
//  Created by Oore Fasawe on 6/30/22.
//

#import "SceneDelegate.h"
#import <Parse/Parse.h>

@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    PFUser *user = [PFUser currentUser];
    if (user != nil) {
        if([user[@"isThrower"] isEqual:@0]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *timelineTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TimelineTabBarController"];
        self.window.rootViewController = timelineTabBarController;
        }
        //if login is from thrower
        else{
            //if thrower is verified
            PFQuery *query = [PFQuery queryWithClassName:@"Thrower"];
            [query whereKey:@"throwerName" equalTo:user.username];
            [query whereKey:@"verified" equalTo:@YES];
            [query findObjectsInBackgroundWithBlock:^(NSArray  *throwersList, NSError *error) {
                if (throwersList.count){
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UINavigationController *throwerTimelineNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ThrowerTimelineNavigationController"];
                    self.window.rootViewController = throwerTimelineNavigationController;
                }
                else{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UINavigationController *throwerWaitScreenNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"ThrowerWaitScreenNavigationController"];
                    self.window.rootViewController = throwerWaitScreenNavigationController;
                }

            }];
        }
    }
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
