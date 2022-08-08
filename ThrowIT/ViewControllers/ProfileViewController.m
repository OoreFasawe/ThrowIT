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
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) NSMutableArray *partiesAttended;
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
    self.seenPartiesTableView.rowHeight = UITableViewAutomaticDimension;
    [self fetchAttendedParties];
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
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if(!error){
            self.users = (NSMutableArray *) users;
            [self.profileTableView reloadData];
        }
    }];
}

-(void)fetchAttendedParties{
    PFQuery *partyQuery = [PFQuery queryWithClassName:@"Check_In"];
    [partyQuery whereKey:USER equalTo:[PFUser currentUser]];
    [partyQuery includeKey:PARTYKEY];
    [partyQuery orderByDescending:CREATEDAT];
    //[partyQuery whereKey:PARTYKEY[@"endDate"] lessThan:[NSDate now]];
    [partyQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable checkIns, NSError * _Nullable error) {
            if(!error)
            {
                self.partiesAttended = (NSMutableArray *) checkIns;
                [self.seenPartiesTableView reloadData];
            }
            else
                NSLog(@"%@", error.localizedDescription);
    }];
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
    CGAffineTransform translateCenter = CGAffineTransformMakeTranslation(self.view.center.x - profileImageExpand.view.center.x, self.view.center.y - profileImageExpand.view.center.y);
    if(profileImageExpand.state == UIGestureRecognizerStateBegan){
        [UIView animateWithDuration:DEFAULTDURATION animations:^{
            profileImageExpand.view.layer.cornerRadius = profileImageExpand.view.frame.size.height/5;
            profileImageExpand.view.layer.zPosition = MAXFLOAT;
            profileImageExpand.view.transform = CGAffineTransformScale(translateCenter, 2.5, 2.5);
        } completion:nil];
    }
    if(profileImageExpand.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:DEFAULTDURATION animations:^{
            profileImageExpand.view.layer.cornerRadius = profileImageExpand.view.frame.size.height/5;
            profileImageExpand.view.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *profileCell;
    if(tableView == self.seenPartiesTableView){
        AttendedPartyCell *attendedPartyCell = [self.seenPartiesTableView dequeueReusableCellWithIdentifier:@"AttendedPartyCell"];
        attendedPartyCell.layer.cornerRadius = 10;
        attendedPartyCell.layer.borderWidth = 0.05;
        Check_In *checkIn = self.partiesAttended[indexPath.section];
        Party *party = checkIn.party;
        attendedPartyCell.partyNameLabel.text = party.name;
        attendedPartyCell.partyThemeLabel.text= party.partyDescription;
        attendedPartyCell.throwerProfilePicture.layer.borderWidth = 0.1;
        attendedPartyCell.throwerProfilePicture.layer.cornerRadius = attendedPartyCell.throwerProfilePicture.frame.size.height/2;
        PFQuery *throwerQuery = [PFQuery queryWithClassName:THROWERCLASS];
        [throwerQuery includeKey:THROWERKEY];
        [throwerQuery whereKey:THROWERKEY equalTo:party.partyThrower];
        [throwerQuery getFirstObjectInBackgroundWithBlock:^(PFObject * thrower, NSError * error) {
            if(!error){
                attendedPartyCell.partyRatingLabel.text = [NSString stringWithFormat:@"Rating: %@ / 5", thrower[THROWERRATING]];
                attendedPartyCell.throwerProfilePicture.file = thrower[THROWERKEY][USERPROFILEPHOTOKEY];
                [attendedPartyCell.throwerProfilePicture loadInBackground];
                attendedPartyCell.throwerNameLabel.text = [NSString stringWithFormat:@". %@", thrower[@"throwerName"]];
            }
            else
                NSLog(@"%@", error.localizedDescription);
        }];
        if([party.endTime laterDate:[NSDate now]] == party.endTime)
            attendedPartyCell.partyTimeLabel.text = @". Now";
        else
            attendedPartyCell.partyTimeLabel.text = [NSString stringWithFormat:@". %@", [NSDate shortTimeAgoSinceDate:party.startTime]];
        [self partyHeadCountQuery:party withAttendedPartyCell:attendedPartyCell];
        profileCell = attendedPartyCell;
    }
    
    if(tableView == self.profileTableView){
        PartyBoardCell *partyBoardCell = [self.profileTableView dequeueReusableCellWithIdentifier:@"RankCell"];
        PFUser *user = self.users[indexPath.section];
        
        if([user[USERUSERNAMEKEY] isEqualToString:[PFUser currentUser][USERUSERNAMEKEY]]){
            partyBoardCell.usernameLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
            partyBoardCell.userPartiesAttendedLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
            partyBoardCell.userRankLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
            partyBoardCell.usernameLabel.text = @"You";
        }
        else
            partyBoardCell.usernameLabel.text = user[USERUSERNAMEKEY];
        partyBoardCell.userRankLabel.text = [NSString stringWithFormat:@"%ld. ", (long)indexPath.section + 1];
        partyBoardCell.userPartiesAttendedLabel.text = [NSString stringWithFormat:@"%@", user[PARTIESATTENDEDKEY]];
        partyBoardCell.userProfilePhotoView.layer.cornerRadius = partyBoardCell.userProfilePhotoView.frame.size.height / 2;
        partyBoardCell.userProfilePhotoView.layer.borderWidth = 0.05;
        partyBoardCell.userProfilePhotoView.file = user[USERPROFILEPHOTOKEY];
        [partyBoardCell.userProfilePhotoView loadInBackground];
        profileCell = partyBoardCell;
    }
    return profileCell;
}

-(void)partyHeadCountQuery:(Party *) party withAttendedPartyCell:(AttendedPartyCell *) attendedPartyCell{
    PFQuery *headCountQuery = [PFQuery queryWithClassName:@"Check_In"];
    [headCountQuery whereKey:PARTYKEY equalTo:party];
    [headCountQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        attendedPartyCell.partyHeadCountLabel.text = [NSString stringWithFormat:@"Headcount: %d", number];
    }];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger numberToReturn = 0;
    if(tableView == self.seenPartiesTableView)
        numberToReturn = self.partiesAttended.count;
    if(tableView == self.profileTableView)
        numberToReturn = self.users.count;
    return numberToReturn;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (IBAction)didChangeSegment:(id)sender {
    UISegmentedControl *profileSegmentedControl = sender;
    if(profileSegmentedControl.selectedSegmentIndex == 1){
        [UIView animateWithDuration:DEFAULTDURATION animations:^{
            self.profileTableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 1.f);
            self.seenPartiesTableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 1.f);
        } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:DEFAULTDURATION animations:^{
            self.seenPartiesTableView.transform = CGAffineTransformMakeTranslation(1.f, 1.f);
            self.profileTableView.transform = CGAffineTransformMakeTranslation(1.f, 1.f);
        } completion:nil];
    }
}


@end
