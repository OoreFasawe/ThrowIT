//
//  TopPartyCell.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "Party.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Utility.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopPartyCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *partyNameLabel;
@property (strong, nonatomic) Party *topParty;
@property (strong, nonatomic) IBOutlet UILabel *partyDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *goingButton;
@property (strong, nonatomic) IBOutlet UILabel *goingCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyRatingLabel;
@end

NS_ASSUME_NONNULL_END
