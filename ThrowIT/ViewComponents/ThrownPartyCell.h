//
//  ThrownPartyCell.h
//  ThrowIT
//
//  Created by Oore Fasawe on 8/8/22.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ThrownPartyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet PFImageView *thrownPartyImageView;
@property (strong, nonatomic) IBOutlet UILabel *thrownPartyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *thrownPartyTimeAgoLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyThemeLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyHeadCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyRatingLabel;

@end

NS_ASSUME_NONNULL_END
