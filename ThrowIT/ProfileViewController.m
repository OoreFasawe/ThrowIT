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


-(void)fetchUser{
    PFQuery *userQuery = [PFQuery queryWithClassName:USERCLASS];
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

@end
