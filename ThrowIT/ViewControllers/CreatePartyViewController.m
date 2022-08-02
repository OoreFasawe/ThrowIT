//
//  CreatePartyViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/11/22.
//

#import "CreatePartyViewController.h"
#import <Parse/Parse.h>
@import GooglePlaces;

@interface CreatePartyViewController () <GMSAutocompleteViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *partyNameField;
@property (strong, nonatomic) IBOutlet UITextField *partyDescriptionField;
@property (strong, nonatomic) IBOutlet UITextField *partyLocationField;
@property (strong, nonatomic) NSString *partyLocationName;
@property (strong, nonatomic) NSString *partyLocationId;
@property (strong, nonatomic) NSDate *partyDateStart;
@property (strong, nonatomic) NSDate *partyDateEnd;
@property (strong, nonatomic) IBOutlet PFImageView *partyImageView;
@property (strong, nonatomic) IBOutlet UIDatePicker *partyDateTimePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *partyDateTimePickerEnd;
@property (nonatomic) CLLocationCoordinate2D partyCoordinate;
@end

@implementation CreatePartyViewController{
    GMSAutocompleteFilter *filter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.partyImageView.layer.cornerRadius = 10;
}

- (IBAction)chooseLocation:(id)sender {
    [self autocompleteClicked];
}
- (IBAction)showImagePickingOptions:(id)sender {
    [Utility showImageTakeOptionSheetOnViewController:self withTitleString:ADDPARTYPHOTO];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self.partyImageView setImage:[Utility resizeImage:editedImage withSize:CGSizeMake(500, 500)]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)throwParty:(id)sender {
    if([self.partyNameField.text isEqual:EMPTY] || [self.partyDescriptionField.text isEqual:EMPTY] || [self.partyLocationField.text isEqual:EMPTY]){
        //TODO: show missing fields alert
    }
    else{
        Party *party = [Party new];
        [Party postNewParty:party withPartyName:self.partyNameField.text withDescription:self.partyDescriptionField.text withStartTime:self.partyDateStart withEndTime:self.partyDateEnd withSchoolName:nil withPartyPhoto:self.partyImageView.image withLocationName:self.partyLocationName withLocationAddress:self.partyLocationField.text withLocationCoordinate:self.partyCoordinate withLocationId:self.partyLocationId withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(error){
                NSLog(@"%@", error.localizedDescription);
            }
            else{
                [self.delegate didCreateParty:party];
            }
        }];
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (void)autocompleteClicked {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID | GMSPlaceFieldCoordinate | GMSPlaceFieldFormattedAddress | GMSPlaceFieldPlaceID);
    acController.placeFields = fields;
    filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
    acController.autocompleteFilter = filter;
    [self presentViewController:acController animated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
    didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.partyLocationName = place.name;
    self.partyLocationField.text = place.formattedAddress;
    self.partyCoordinate= place.coordinate;
    self.partyLocationId = place.placeID;
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible  = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)didSetPartyStartDate:(id)sender {
    UIDatePicker* datePicker = sender;
    self.partyDateStart = datePicker.date;
    self.partyDateTimePickerEnd.date = [NSDate dateWithTimeInterval:TIMEINTERVAL sinceDate: datePicker.date];
    self.partyDateEnd = self.partyDateTimePickerEnd.date;
}

- (IBAction)didSetPartyEndDate:(id)sender {
    UIDatePicker* datePicker = sender;
    self.partyDateTimePickerEnd.date = datePicker.date;
}

@end
