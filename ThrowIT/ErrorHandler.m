//
//  ErrorHandler.m
//  ThrowIT
//
//  Created by Oore Fasawe on 8/9/22.
//

#import "ErrorHandler.h"

@implementation ErrorHandler

+(instancetype)shared{
    static ErrorHandler *errorHandler  = nil;
    errorHandler = [[self alloc] init];
    return errorHandler;
}

//UIAlertController *networkAlert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
//UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    [self fetchMovies];
//[self presentViewController:networkAlert animated:YES completion:^{
//    //optional code for what happens after the alert controller has finished presenting
//}];

-(void)showCheckInErrorMessage:(NSString* )message onViewController:(UIViewController *)viewController{
    dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertController *checkInAlert = [UIAlertController alertControllerWithTitle:CHECKINFAILED message:message preferredStyle:UIAlertControllerStyleAlert];
    [checkInAlert addAction:[self addOkAction]];
    
    self.customAlert = checkInAlert;
    [viewController presentViewController:self.customAlert animated:YES completion:nil];
    });
}

-(void)showNetworkErrorMessageOnViewController:(UIViewController *)viewController withCompletion:(void (^)(BOOL tryAgain))completion{
    UIAlertController *networkAlert = [UIAlertController alertControllerWithTitle:CANNNOGETPARTIES message:NOINTERNET preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:TRYAGAIN style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completion(YES);
    }];
    [networkAlert addAction:tryAgainAction];
    self.customAlert = networkAlert;
    [viewController presentViewController:self.customAlert animated:YES completion:nil];
}

-(UIAlertAction *)addOkAction{
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:OK style:UIAlertActionStyleDefault handler:nil];
    return okAction;
}
@end
