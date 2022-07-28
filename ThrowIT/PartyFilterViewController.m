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
    self.distanceLabel.text = [NSString stringWithFormat:DISTANCELABELTEXTFORMAT, self.distanceSlider.value];
}

-(void)setAttendanceLabeltext{
    self.attendanceLabel.text = [NSString stringWithFormat:ATTENDANCELABELTEXTFORMAT, self.attendanceSegmentedController.selectedSegmentIndex];
}

-(void)setRatingLabeltext{
    self.ratingLabel.text = [NSString stringWithFormat:RATINGLABELTEXTFORMAT, self.ratingStepper.value / 2.0];
}
- (IBAction)setPartyFilters:(id)sender {
    [self.delegate filterListByDistance:self.distanceSlider.value byPartyCount: (int)self.attendanceSegmentedController.selectedSegmentIndex byRating: self.ratingStepper.value/ 2.0];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
