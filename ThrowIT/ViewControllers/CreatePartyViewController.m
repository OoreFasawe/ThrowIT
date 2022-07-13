//
//  CreatePartyViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/11/22.
//

#import "CreatePartyViewController.h"
#import <Parse/Parse.h>


@interface CreatePartyViewController ()
@property (strong, nonatomic) IBOutlet UITextField *partyNameField;
@property (strong, nonatomic) IBOutlet UITextField *partyDescriptionField;

@end

@implementation CreatePartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)throwParty:(id)sender {
    if([self.partyNameField.text isEqual:@""] || [self.partyDescriptionField.text isEqual:@""])
    {
        
    }
    else{
        [Party postNewParty:self.partyNameField.text withDescription:self.partyDescriptionField.text withStartTime:nil withEndTime:nil withSchoolName:nil withBackGroundImage:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(error){
                NSLog(@"%@", error.localizedDescription);
            }
            else{
                Party *newParty = [Party new];
                newParty.name = self.partyNameField.text;
                newParty.partyDescription = self.partyDescriptionField.text;

                newParty.numberAttending= 0;
                newParty.partyThrower = [PFUser currentUser];
                [self.delegate didCreateParty:newParty];
            }
        }];
        [self dismissViewControllerAnimated:true completion:nil];
        
        
}
    
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
