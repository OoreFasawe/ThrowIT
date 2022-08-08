//
//  ThrowBoardCell.h
//  ThrowIT
//
//  Created by Oore Fasawe on 8/8/22.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface ThrowBoardCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *throwerRankLabel;
@property (strong, nonatomic) IBOutlet PFImageView *throwerProfilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *throwerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *thrownPartyCountLabel;

@end

NS_ASSUME_NONNULL_END
