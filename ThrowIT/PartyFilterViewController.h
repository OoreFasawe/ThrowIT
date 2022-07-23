//
//  PartyFilterViewController.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/22/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PartyFilterViewControllerDelegate <NSObject>

- (void)filterListByDistance:(double) distance byPartyCount:(int) partyCount byRating:(double) rating;

@end

@interface PartyFilterViewController : UIViewController
@property (nonatomic, strong) id<PartyFilterViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
