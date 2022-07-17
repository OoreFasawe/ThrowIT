//
//  OpenMapDirections.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/14/22.
//


#import "OpenMapDirections.h"

@implementation OpenMapDirections

+(void)presentWithViewController:(UIViewController *)viewController withSourceView:(UIView *)sourceView withLocationCoordinate:(CLLocationCoordinate2D) location{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Open Directions" message:@"Choose an app to open directions." preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Google Maps" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?daddr=(%lf,%lf)&directionsmode=driving&zoom=14&views=traffic", location.latitude, location.longitude];
        NSURL *url = [NSURL URLWithString:urlString];
        
        [[UIApplication sharedApplication] openURL:url];

    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Apple Maps" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:location addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placeMark];
        mapItem.name = @"Destination";
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsDirectionsModeKey, nil];
        [mapItem openInMapsWithLaunchOptions:options];
    }]];
    
    [[actionSheet popoverPresentationController] setSourceRect:sourceView.bounds];
    [[actionSheet popoverPresentationController] setSourceView:sourceView];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [viewController presentViewController:actionSheet animated:YES completion:^{}];
    
}


//
//    // If you are calling the coordinate from a Model, don't forgot to pass it in the function parenthesis.
//    static func present(in viewController: UIViewController, sourceView: UIView) {
//        let actionSheet = UIAlertController(title: "Open Location", message: "Choose an app to open direction", preferredStyle: .actionSheet)
//        actionSheet.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { _ in
//            // Pass the coordinate inside this URL
//            let url = URL(string: "comgooglemaps://?daddr=48.8566,2.3522)&directionsmode=driving&zoom=14&views=traffic")!
//UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }))
//        actionSheet.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { _ in
//            // Pass the coordinate that you want here
//            let coordinate = CLLocationCoordinate2DMake(48.8566,2.3522)
//            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
//            mapItem.name = "Destination"
//            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
//        }))
//        actionSheet.popoverPresentationController?.sourceRect = sourceView.bounds
//        actionSheet.popoverPresentationController?.sourceView = sourceView
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        viewController.present(actionSheet, animated: true, completion: nil
@end
