//
//  OpenMapDirections.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/14/22.
//


#import "OpenMapDirections.h"

@implementation OpenMapDirections

+(void)presentWithViewController:(UIViewController *)viewController withSourceView:(UIView *)sourceView withLocationCoordinate:(CLLocationCoordinate2D) location{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:OPENDIRECTIONSTITLE message: OPENDIRECTIONSMESSAGE preferredStyle:(UIAlertControllerStyleActionSheet)];
    [actionSheet addAction:[UIAlertAction actionWithTitle: ALERTACTIONGOOGLEMAPSTITLE style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSString *urlString = [NSString stringWithFormat: LAUNCHURLFORGOOGLEMAPS, location.latitude, location.longitude];
        NSURL *url = [NSURL URLWithString:urlString];
        [[UIApplication sharedApplication] openURL:url];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle: ALERTACTIONAPPLEMAPSTITLE style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placeMark];
        mapItem.name = DESTINATION;
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsDirectionsModeKey, nil];
        [mapItem openInMapsWithLaunchOptions:options];
    }]];
    [[actionSheet popoverPresentationController] setSourceRect:sourceView.bounds];
    [[actionSheet popoverPresentationController] setSourceView:sourceView];
    [actionSheet addAction:[UIAlertAction actionWithTitle:CANCEL style:UIAlertActionStyleCancel handler:nil]];
    [viewController presentViewController:actionSheet animated:YES completion:^{}];
}
@end
