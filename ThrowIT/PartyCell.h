//
//  PartyCell.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/6/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PartyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *partyName;
@property (strong, nonatomic) IBOutlet UILabel *partyTime;
@property (strong, nonatomic) IBOutlet UILabel *partyGoingCount;
@property (strong, nonatomic) IBOutlet UILabel *partyRating;

@end

NS_ASSUME_NONNULL_END
