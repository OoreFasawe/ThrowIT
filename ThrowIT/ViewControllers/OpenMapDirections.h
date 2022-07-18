//
//  OpenMapDirections.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/14/22.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@import GoogleMaps;

NS_ASSUME_NONNULL_BEGIN

@interface OpenMapDirections : NSObject
+(void)presentWithViewController:(UIViewController *)viewController withSourceView:(UIView *)sourceView withLocationCoordinate:(CLLocationCoordinate2D) location;
@end

NS_ASSUME_NONNULL_END
