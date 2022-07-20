//
//  APIManager.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/18/22.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Utility.h"

NS_ASSUME_NONNULL_BEGIN
@interface APIManager : NSObject<CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@property (nonatomic, strong) NSDictionary *distanceDetails;
+(instancetype)shared;
-(void)loadDistanceDataIntoArray:(NSMutableArray *)array withDestinationLocation:(NSString *)destinationPlaceId withArrayIndex:(int) arrayIndex  withCount:(NSUInteger)count withCompletionHandler:(void (^)(BOOL success ))completion;
-(void)locationManagerInit;
@end

NS_ASSUME_NONNULL_END
