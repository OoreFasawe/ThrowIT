//
//  CreatePartyViewController.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "Party.h"

NS_ASSUME_NONNULL_BEGIN
@protocol CreatePartyViewControllerDelegate <NSObject>
- (void)didCreateParty:(Party *)party;
@end

@interface CreatePartyViewController : UIViewController
@property (nonatomic, weak) id<CreatePartyViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
