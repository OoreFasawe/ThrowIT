//
//  AppDelegate.m
//  ThrowIT
//
//  Created by Oore Fasawe on 6/30/22.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
@import  GoogleMaps;
@import GooglePlaces;
@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *path = [[NSBundle mainBundle] pathForResource: KEYSFILENAME ofType: KEYSFILETYPE];
    NSDictionary *keysDict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *parseAppId = [keysDict objectForKey: PARSEAPPID];
    NSString *parseClientKey = [keysDict objectForKey: PARSECLIENTKEY];
    NSString *googleMapsAPIKey = [keysDict objectForKey: GOOGLEMAPSAPIKEY];
    // Override point for customization after application launch.
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
            configuration.applicationId = parseAppId;
            configuration.clientKey = parseClientKey;
            configuration.server = PARSESERVER;
        }];
    [Parse initializeWithConfiguration:config];
    [GMSServices provideAPIKey:googleMapsAPIKey];
    [GMSPlacesClient provideAPIKey:googleMapsAPIKey];
        return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
