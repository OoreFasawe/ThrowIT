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
    [self loadPartyDetails];
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
    self.mapView.layer.cornerRadius = 20;
    self.mapView.layer.borderWidth = 0.05;
    self.viewForMapView.hidden = YES;
    self.mapView.delegate = self;
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake(self.mapView.camera.target.latitude, self.mapView.camera.target.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:mapCenter];
    marker.map = self.mapView;
}

-(void)loadPartyDetails{
    self.partyNameLabel.text = self.party.name;
    if([self.party isGoingOn]){
        [Check_In userIsCheckedIn:self.party withCompletion:^(BOOL checkInExists) {
            if(checkInExists){
                self.checkInButton.layer.backgroundColor = [[UIColor greenColor] CGColor];
            }
        }];
        self.checkInButton.hidden = false;
    }
    else{
        self.checkInButton.hidden = true;
    }
}

- (IBAction)didTapCheckIn:(id)sender {
    if([self.party isGoingOn]){
        [Check_In userIsCheckedIn:self.party withCompletion:^(BOOL checkInExists) {
            if(!checkInExists){
                [[APIManager shared] loadDistanceDataFromLocation:self.party.partyLocationId withCompletionHandler:^(NSString *distance) {
                    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                    f.numberStyle = NSNumberFormatterDecimalStyle;
                    if(1.0 >= [[f numberFromString:[distance componentsSeparatedByString:SPACE][0]] doubleValue] || [[distance componentsSeparatedByString:SPACE][1] isEqualToString:FEET]){
                        [Check_In postNewCheckInForParty:self.party withCompletion:^(BOOL succeeded, NSError *error) {
                            [self.delegate reloadCells];
                        }];
                        PFUser *user = [PFUser currentUser];
                        [user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                            int partiesAttendedCount = [user[PARTIESATTENDEDKEY] intValue];
                            partiesAttendedCount += 1;
                            user[PARTIESATTENDEDKEY] = [NSNumber numberWithInt:partiesAttendedCount];
                            [user saveInBackground];
                        }];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.checkInButton.layer.backgroundColor = [[UIColor greenColor] CGColor];
                            self.checkInButton.userInteractionEnabled = NO;
                        });
                    }
                    else{
                        [[ErrorHandler shared] showCheckInErrorMessage:TOOFARFROMPARTY onViewController:self];
                    }
                }];
            }
            else{
                [[ErrorHandler shared] showCheckInErrorMessage:CHECKINEXISTS onViewController:self];
            }
        }];
    }
    else{
        [[ErrorHandler shared] showCheckInErrorMessage:PARTYENDED onViewController:self];
    }
}

@end
