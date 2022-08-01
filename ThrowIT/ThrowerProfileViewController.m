//
//  ThrowerProfileViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/28/22.
//

#import "ThrowerProfileViewController.h"
#import "Utility.h"

@interface ThrowerProfileViewController ()
@property (strong, nonatomic) IBOutlet PFImageView *throwerProfileImageView;
@property (strong, nonatomic) IBOutlet UILabel *throwerPartiesThrownCount;
@property (strong, nonatomic) IBOutlet UISegmentedControl *throwerSegmentedController;
@property (strong, nonatomic) IBOutlet UILabel *throwerNameLabel;
@end

@implementation ThrowerProfileViewController

- (void)viewDidLoad {
    
    self.throwerProfileImageView.layer.cornerRadius = self.throwerProfileImageView.frame.size.height/10;
    self.throwerProfileImageView.layer.borderWidth = 0.05;
    [self fetchThrower];
    [super viewDidLoad];
}
- (IBAction)chooseThrowerProfilePhoto:(id)sender {
    [Utility showImageTakeOptionSheetOnViewController:self withTitleString:ADDPROFILEPHOTO];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self.throwerProfileImageView setImage:[Utility resizeImage:editedImage withSize:CGSizeMake(500, 500)]];
    PFUser *user = [PFUser currentUser];
    user[USERPROFILEPHOTOKEY] = [Utility getPFFileFromImage:self.throwerProfileImageView.image];
    [user saveInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fetchThrower{
    PFQuery *userQuery = [PFQuery queryWithClassName:USERCLASS];
    [userQuery includeKey:PARTIESATTENDEDKEY];
    [userQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *user, NSError *error) {
        if(!error){
            self.throwerNameLabel.text = user[USERUSERNAMEKEY];
            self.throwerProfileImageView.file = user[USERPROFILEPHOTOKEY];
            [self.throwerProfileImageView loadInBackground];
        }
    }];
}
@end
