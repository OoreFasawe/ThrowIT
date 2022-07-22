//
//  PartyFilterViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/22/22.
//

#import "PartyFilterViewController.h"

@interface PartyFilterViewController ()
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UISlider *distanceSlider;
@property (strong, nonatomic) IBOutlet UISegmentedControl *attendanceSegmentedController;
@property (strong, nonatomic) IBOutlet UILabel *attendanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UIStepper *ratingStepper;

@end

@implementation PartyFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDistanceLabeltext];
    [self setAttendanceLabeltext];
    [self setRatingLabeltext];
    // Do any additional setup after loading the view.
}
- (IBAction)didPickDistance:(id)sender {
    [self setDistanceLabeltext];
}

- (IBAction)didPickAttendance:(id)sender {
    [self setAttendanceLabeltext];
}
- (IBAction)didPickRating:(id)sender {
    [self setRatingLabeltext];
}

-(void)setDistanceLabeltext{
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f miles", self.distanceSlider.value];
}

-(void)setAttendanceLabeltext{
    int attendanceNumbers[] = {10, 25, 50, 100, 100};
    if(self.attendanceSegmentedController.selectedSegmentIndex != self.attendanceSegmentedController.numberOfSegments - 1)
        self.attendanceLabel.text = [NSString stringWithFormat:@"%d and below", attendanceNumbers[self.attendanceSegmentedController.selectedSegmentIndex]];
    else
        self.attendanceLabel.text = [NSString stringWithFormat:@"%d and above", attendanceNumbers[self.attendanceSegmentedController.selectedSegmentIndex]];
}

-(void)setRatingLabeltext{
    self.ratingLabel.text = [NSString stringWithFormat:@"Min rating %.1f / 5", self.ratingStepper.value / 2.0];
}
- (IBAction)setPartyFilters:(id)sender {
    [self.delegate filterListByDistance:self.distanceSlider.value];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end