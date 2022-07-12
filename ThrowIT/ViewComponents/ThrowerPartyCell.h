//
//  ThrowerPartyCell.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "Party.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThrowerPartyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *partyName;
@property (strong, nonatomic) IBOutlet UILabel *numberAttendingParty;
@property (strong, nonatomic) IBOutlet UILabel *partyDate;
@property (strong, nonatomic) IBOutlet UILabel *partyDescription;
@property (strong, nonatomic) Party *party;

@end

NS_ASSUME_NONNULL_END
