//
//  SearchCell.h
//  ThrowIT
//
//  Created by Ooreoluwa Fasawe on 28/08/2022.
//

#import <UIKit/UIKit.h>
@import Parse;

NS_ASSUME_NONNULL_BEGIN

@interface SearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *userProfilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *userUserNameLabel;
@end

NS_ASSUME_NONNULL_END
