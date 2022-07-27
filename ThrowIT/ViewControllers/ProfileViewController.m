//
//  ProfileViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/17/22.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *classLabel;
@property (strong, nonatomic) IBOutlet UILabel *partiesAttendedLabel;
@property (strong, nonatomic) IBOutlet PFImageView *profilePicture;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchUser];
}

- (IBAction)onTapProfilePicture:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:ADDPROFILEPHOTO message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        [actionSheet addAction:[UIAlertAction actionWithTitle:TAKEPHOTO style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [Utility TakeOrChooseImage:self withSourceType:UIImagePickerControllerSourceTypeCamera];
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:CHOOSEFROMLIBRARY style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [Utility TakeOrChooseImage:self withSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }]];
        [[actionSheet popoverPresentationController] setSourceRect:self.view.bounds];
        [[actionSheet popoverPresentationController] setSourceView:self.view];
        [actionSheet addAction:[UIAlertAction actionWithTitle:CANCEL style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:actionSheet animated:YES completion:^{}];
}

-(void)fetchUser{
    PFQuery *userQuery = [PFQuery queryWithClassName:USERCLASS];
    [userQuery includeKey:PARTIESATTENDEDKEY];
    [userQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *user, NSError *error) {
        if(!error){
            self.profilePicture.file = user[USERPROFILEPHOTOKEY];
            self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
            self.profilePicture.layer.borderWidth= 0.05;
            [self.profilePicture loadInBackground];
            self.usernameLabel.text = user[USERUSERNAMEKEY];
            self.partiesAttendedLabel.text = [NSString stringWithFormat:@"%@", user[PARTIESATTENDEDKEY]];
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self.profilePicture setImage:[self resizeImage:editedImage withSize:CGSizeMake(500, 500)]];
    PFUser *user = [PFUser currentUser];
    user[USERPROFILEPHOTOKEY] = [Utility getPFFileFromImage:self.profilePicture.image];
    [user saveInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)didLongPressOnProfileImage:(id)sender {
    UILongPressGestureRecognizer *profileImageExpand = sender;
    CGRect profileImageframe = profileImageExpand.view.frame;
    profileImageframe.size.height = profileImageExpand.view.frame.size.height * SIZEMULTIPLIER;
    profileImageframe.size.width = profileImageExpand.view.frame.size.width * SIZEMULTIPLIER;
    if(profileImageExpand.state == UIGestureRecognizerStateBegan){
        [UIView animateWithDuration:DEFAULTDURATION animations:^{
            profileImageExpand.view.layer.zPosition = MAXFLOAT;
            profileImageExpand.view.frame = profileImageframe;
            profileImageExpand.view.transform = CGAffineTransformMakeTranslation(self.view.center.x - profileImageExpand.view.center.x, self.view.center.y - profileImageExpand.view.center.y);
        } completion:nil];
    }
    profileImageframe.size.height = profileImageExpand.view.frame.size.height / SIZEMULTIPLIER;
    profileImageframe.size.width = profileImageExpand.view.frame.size.width / SIZEMULTIPLIER;
    if(profileImageExpand.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:DEFAULTDURATION animations:^{
            profileImageExpand.view.frame = profileImageframe;
            profileImageExpand.view.transform = CGAffineTransformMakeTranslation(ORIGINALXPOSITION, ORIGINALYPOSITION);
        } completion:nil];
    }
}

@end
