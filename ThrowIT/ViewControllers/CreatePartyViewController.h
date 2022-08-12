//
//  CreatePartyViewController.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "Party.h"
#import "Utility.h"
#import "ErrorHandler.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN
@protocol CreatePartyViewControllerDelegate <NSObject>
- (void)didCreateParty:(Party *)party;
@end

@interface CreatePartyViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) id<CreatePartyViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
