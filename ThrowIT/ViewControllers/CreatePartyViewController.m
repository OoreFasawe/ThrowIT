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
@property (nonatomic) CLLocationCoordinate2D partyCoordinate;
@end

@implementation CreatePartyViewController{
    GMSAutocompleteFilter *filter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)chooseLocation:(id)sender {
    [self autocompleteClicked];
}

- (IBAction)throwParty:(id)sender {
    if([self.partyNameField.text isEqual:@""] || [self.partyDescriptionField.text isEqual:@""] || [self.partyLocationField.text isEqual:@""]){
        //TODO: show missing fields alert
    }
    else{
        Party *party = [Party new];
        [Party postNewParty:party withPartyName:self.partyNameField.text withDescription:self.partyDescriptionField.text withStartTime:nil withEndTime:nil withSchoolName:nil withBackGroundImage:nil withLocationName:self.partyLocationName withLocationAddress:self.partyLocationField.text withLocationCoordinate:self.partyCoordinate withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
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

// Present the autocomplete view controller when the button is pressed.
- (void)autocompleteClicked {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;

    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID | GMSPlaceFieldCoordinate | GMSPlaceFieldFormattedAddress);
    acController.placeFields = fields;

    // Specify a filter.
    filter = [[GMSAutocompleteFilter alloc] init];
    filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
    acController.autocompleteFilter = filter;

    // Display the autocomplete view controller.
    [self presentViewController:acController animated:YES completion:nil];
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
    didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place ID %@", place.placeID);
    self.partyLocationName = place.name;
    self.partyLocationField.text = place.formattedAddress;
    self.partyCoordinate= place.coordinate;
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible  = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
