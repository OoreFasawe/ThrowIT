//
//  DetailsViewController.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/12/22.
//

#import <UIKit/UIKit.h>
#import "Party.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Check In.h"
#import "APIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property (nonatomic, strong) Party *party;
@property (nonatomic, strong) GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *checkInButton;
@end

NS_ASSUME_NONNULL_END
