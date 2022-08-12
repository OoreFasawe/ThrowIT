//
//  DetailsViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/12/22.
//
#import "OpenMapDirections.h"
#import "DetailsViewController.h"
#import "DateTools.h"
@import Parse;

@interface DetailsViewController ()<GMSMapViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *detailsScrollView;
@property (strong, nonatomic) IBOutlet UIButton *directionsButton;
@property (strong, nonatomic) IBOutlet PFImageView *throwerProfilePicture;

@property (strong, nonatomic) IBOutlet UILabel *partyNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyThemeLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *partyLocationLabel;
@property (strong, nonatomic) IBOutlet PFImageView *partyImageView;
@property (strong, nonatomic) IBOutlet UILabel *throwerNameLabel;

@property (nonatomic) CLLocationCoordinate2D partyLocation;
@end

@implementation DetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailsScrollView.delegate = self;
    [self loadPartyDetails];
    [self showMap];
}
- (IBAction)goToMapDirections:(id)sender {
    self.partyLocation = CLLocationCoordinate2DMake(self.party.partyCoordinateLatitude, self.party.partyCoordinateLongitude);
    [OpenMapDirections presentWithViewController:self withSourceView:self.view withLocationCoordinate:self.partyLocation];
}
-(void)showMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.party.partyCoordinateLatitude longitude:self.party.partyCoordinateLongitude zoom:MAPZOOMCONSTANT];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, self.detailsScrollView.frame.size.height - (self.view.safeAreaInsets.bottom) - MAPOFFSET, self.view.frame.size.width, MAPHEIGHT) camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.mapView.delegate = self;
    [self.contentView addSubview:self.mapView];
    NSLayoutConstraint *topAlign = [NSLayoutConstraint
                                          constraintWithItem:self.mapView
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                          toItem:self.directionsButton
                                          attribute:NSLayoutAttributeBottom
                                          multiplier:1.0
                                          constant:MAPDISTANCEFROMDIRBUTTON];
    [self.detailsScrollView addConstraint:topAlign];
    NSLayoutConstraint *bottomAlign = [NSLayoutConstraint
                                          constraintWithItem:self.mapView
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.contentView
                                          attribute:NSLayoutAttributeBottom
                                          multiplier:1.0
                                          constant:0];
    [self.view addConstraint:bottomAlign];
    CLLocationCoordinate2D mapCenter = CLLocationCoordinate2DMake(self.mapView.camera.target.latitude, self.mapView.camera.target.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:mapCenter];
    marker.map = self.mapView;
    CGFloat y = CGRectGetMaxY(((UIView*)[self.contentView.subviews lastObject]).frame) + MAPOFFSET;
    self.contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, y);
    self.detailsScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.contentView.frame.size.height);
    [self.detailsScrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.contentView.frame.size.height)];
}

-(void)loadPartyDetails{
    self.contentView.backgroundColor = self.contentViewColor;
    self.throwerNameLabel.text = self.party.partyThrower[USERUSERNAMEKEY];
    self.partyThemeLabel.text = self.party.partyDescription;
    self.partyLocationLabel.text = self.party.partyLocationAddress;
    self.partyDateLabel.text = [NSString stringWithFormat:@"%@, %@", [self.party.startTime formattedDateWithFormat:TIMEFORMAT timeZone:[NSTimeZone localTimeZone]], [self.party.startTime formattedDateWithStyle:NSDateFormatterFullStyle timeZone:[NSTimeZone localTimeZone]]];
    self.partyNameLabel.text = self.party.name;
    self.partyImageView.layer.cornerRadius = 10;
    self.partyImageView.layer.borderWidth = 0.05;
    self.partyImageView.file = self.party.partyPhoto;
    [self.partyImageView loadInBackground];
    self.throwerProfilePicture.layer.cornerRadius = 5;
    self.throwerProfilePicture.layer.borderWidth = 0.05;
    self.throwerProfilePicture.file = self.party.partyThrower[USERPROFILEPHOTOKEY];
    [self.throwerProfilePicture loadInBackground];
    
    if(!self.isFromThrowerAccount){
        if([self.party isGoingOn]){
            [Check_In userIsCheckedIn:self.party withCompletion:^(BOOL checkInExists) {
                if(checkInExists){
                    self.checkInButton.layer.cornerRadius = 5;
                    self.checkInButton.layer.backgroundColor = [[UIColor colorWithRed:0.313725 green:0.784313 blue:0.470588 alpha:1] CGColor];
                    self.checkInButton.userInteractionEnabled = NO;
                    [self.checkInButton setTitle:CHECKED forState:UIControlStateNormal];
                }
            }];
            self.checkInButton.hidden = false;
        }
        else{
            self.checkInButton.hidden = true;
        }
    }
}

- (IBAction)didTapCheckIn:(id)sender {
    if([self.party isGoingOn]){
        [Check_In userIsCheckedIn:self.party withCompletion:^(BOOL checkInExists) {
            if(!checkInExists){
                [[APIManager shared] loadDistanceDataFromLocation:self.party.partyLocationId withCompletionHandler:^(NSString *distance) {
                    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                    f.numberStyle = NSNumberFormatterDecimalStyle;
                    if(MINDISTANCE >= [[f numberFromString:[distance componentsSeparatedByString:SPACE][0]] doubleValue] || [[distance componentsSeparatedByString:SPACE][1] isEqualToString:FEET]){
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
                            self.checkInButton.layer.cornerRadius = 5;
                            self.checkInButton.layer.backgroundColor = [[UIColor colorWithRed:0.313725 green:0.784313 blue:0.470588 alpha:1] CGColor];
                            self.checkInButton.userInteractionEnabled = NO;
                            [self.checkInButton setTitle:CHECKED forState:UIControlStateNormal];
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
