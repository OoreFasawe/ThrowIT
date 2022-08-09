//
//  PartyBoardCell.h
//  Pods
//
//  Created by Oore Fasawe on 8/6/22.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PartyBoardCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userPartiesAttendedLabel;
@property (strong, nonatomic) IBOutlet PFImageView *userProfilePhotoView;
@property (strong, nonatomic) IBOutlet UILabel *userRankLabel;
@end

NS_ASSUME_NONNULL_END
