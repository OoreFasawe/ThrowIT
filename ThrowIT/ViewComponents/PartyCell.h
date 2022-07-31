//
//  PartyCell.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "Party.h"
#import "Utility.h"
#import "CoreHapticsGenerator.h"
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface PartyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *partyName;
@property (strong, nonatomic) IBOutlet UILabel *partyTime;
@property (strong, nonatomic) IBOutlet UILabel *partyGoingCount;
@property (strong, nonatomic) IBOutlet UILabel *partyRating;
@property (strong, nonatomic) IBOutlet UILabel *partyDescription;
@property (strong, nonatomic) Party *party;
@property (strong, nonatomic) IBOutlet UILabel *throwerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyDistance;
@property (strong, nonatomic) IBOutlet PFImageView *throwerProfilePicture;
@property (strong, nonatomic) IBOutlet UIButton *goingButton;
@property (nonatomic, strong) CoreHapticsGenerator *soundGenerator;
- (IBAction)didTapLike:(id)sender;
NS_ASSUME_NONNULL_END
@end
