//
//  ErrorHandler.h
//  ThrowIT
//
//  Created by Oore Fasawe on 8/9/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Utility.h"

NS_ASSUME_NONNULL_BEGIN

@interface ErrorHandler : NSObject

@property (nonatomic, strong) UIAlertController* customAlert;
+(instancetype)shared;
-(void)showCheckInErrorMessage:(NSString* )message onViewController:(UIViewController *)viewController;
-(void)showNetworkErrorMessageOnViewController:(UIViewController *)viewController withCompletion:(void (^)(BOOL tryAgain))completion;
-(void)showMissingFieldsErrorMessageOnViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
