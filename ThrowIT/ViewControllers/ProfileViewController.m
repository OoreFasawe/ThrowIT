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
@property (strong, nonatomic) IBOutlet UITableView *profileTableView;
@property (strong, nonatomic) IBOutlet UITableView *seenPartiesTableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *profileSegmentedControl;
@property (strong, nonatomic) NSMutableArray *users;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchUser];
    self.profileTableView.delegate = self;
    self.profileTableView.dataSource = self;
    self.profileTableView.rowHeight = UITableViewAutomaticDimension;
    self.seenPartiesTableView.delegate = self;
    self.seenPartiesTableView.dataSource = self;
    self.seenPartiesTableView.rowHeight = 106;
    [self fetchUsers];
}

- (IBAction)onTapProfilePicture:(id)sender {
    [Utility showImageTakeOptionSheetOnViewController:self withTitleString:ADDPROFILEPHOTO];
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

-(void)fetchUsers{
    PFQuery *userQuery = [PFQuery queryWithClassName:USERCLASS];
    [userQuery includeKey:PARTIESATTENDEDKEY];
    [userQuery whereKey:USERISTHROWERKEY equalTo:@NO];
    [userQuery orderByDescending:PARTIESATTENDEDKEY];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(!error){
            self.users = (NSMutableArray *) objects;
            [self.profileTableView reloadData];
            [self.seenPartiesTableView reloadData];
        }
    }];
}

-(void)fetchSeenParties{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self.profilePicture setImage:[Utility resizeImage:editedImage withSize:CGSizeMake(500, 500)]];
    PFUser *user = [PFUser currentUser];
    user[USERPROFILEPHOTOKEY] = [Utility getPFFileFromImage:self.profilePicture.image];
    [user saveInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *profileCell;
    if(tableView == self.seenPartiesTableView){
        PartyCell *seenPartyCell = [self.seenPartiesTableView dequeueReusableCellWithIdentifier:@"PartyCell"];
        
        profileCell = seenPartyCell;
    }
    if(tableView == self.profileTableView){
        PartyBoardCell *partyBoardCell = [self.profileTableView dequeueReusableCellWithIdentifier:@"RankCell"];
        PFUser *user = self.users[indexPath.section];
        partyBoardCell.userRankLabel.text = [NSString stringWithFormat:@"%ld. ", (long)indexPath.section + 1];
        partyBoardCell.usernameLabel.text = user[USERUSERNAMEKEY];
        partyBoardCell.userPartiesAttendedLabel.text = [NSString stringWithFormat:@"%@", user[PARTIESATTENDEDKEY]];
        partyBoardCell.userProfilePhotoView.layer.cornerRadius = partyBoardCell.userProfilePhotoView.frame.size.height / 2;
        partyBoardCell.userProfilePhotoView.layer.borderWidth = 0.05;
        partyBoardCell.userProfilePhotoView.file = user[USERPROFILEPHOTOKEY];
        [partyBoardCell.userProfilePhotoView loadInBackground];
        profileCell = partyBoardCell;
    }
    return profileCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.users.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

@end
