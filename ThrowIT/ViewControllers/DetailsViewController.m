//
//  DetailsViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/12/22.
//
#import "OpenMapDirections.h"
#import "DetailsViewController.h"

@interface DetailsViewController ()<GMSMapViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *partyNameLabel;
@property (nonatomic) CLLocationCoordinate2D partyLocation;
@property (strong, nonatomic) IBOutlet UIView *viewForMapView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.partyNameLabel.text = self.party.name;
    [self showMap];
}
- (IBAction)goToMapDirections:(id)sender {
    self.partyLocation = CLLocationCoordinate2DMake(self.party.partyCoordinateLatitude, self.party.partyCoordinateLongitude);
    [OpenMapDirections presentWithViewController:self withSourceView:self.view withLocationCoordinate:self.partyLocation];
}
-(void)showMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.party.partyCoordinateLatitude longitude:self.party.partyCoordinateLongitude zoom:16];
    self.mapView = [GMSMapView mapWithFrame:self.viewForMapView.frame camera:camera];
    self.mapView.myLocationEnabled = YES;
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;  
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake(self.mapView.camera.target.latitude, self.mapView.camera.target.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:mapCenter];
    marker.map = self.mapView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
