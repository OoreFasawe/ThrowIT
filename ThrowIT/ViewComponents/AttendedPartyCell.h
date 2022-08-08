//
//  AttendedPartyCell.h
//  ThrowIT
//
//  Created by Oore Fasawe on 8/7/22.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface AttendedPartyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet PFImageView *throwerProfilePicture;
@property (strong, nonatomic) IBOutlet UILabel *partyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *throwerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyThemeLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyHeadCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyRatingLabel;

@end

NS_ASSUME_NONNULL_END
