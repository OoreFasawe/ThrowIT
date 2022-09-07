//
//  ProfileViewController.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/17/22.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
@import Parse;
#import "PartyBoardCell.h"
#import "PartyCell.h"
#import "AttendedPartyCell.h"
#import "Check In.h"
#import "DateTools.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) PFUser *currentUser;
@end

NS_ASSUME_NONNULL_END
