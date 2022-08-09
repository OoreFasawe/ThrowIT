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

-(void)showCheckInErrorMessage:(NSString* )message onViewController:(UIViewController *)viewController{
    dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertController *checkInAlert = [UIAlertController alertControllerWithTitle:CHECKINFAILED message:message preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:OK style:UIAlertActionStyleDefault handler:nil];
    [checkInAlert addAction:okAction];
    
    self.customAlert = checkInAlert;
    [viewController presentViewController:self.customAlert animated:YES completion:nil];
    });
}

@end
