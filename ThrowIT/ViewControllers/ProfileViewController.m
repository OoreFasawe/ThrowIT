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
    self.profileTableView.delegate = self;
    self.profileTableView.dataSource = self;
    self.profileTableView.rowHeight = UITableViewAutomaticDimension;
    self.seenPartiesTableView.delegate = self;
    self.seenPartiesTableView.dataSource = self;
    self.seenPartiesTableView.rowHeight = UITableViewAutomaticDimension;
    if(!self.currentUser){
        self.currentUser = [PFUser currentUser];
    }
    [self fetchUser];
    [self fetchAttendedParties];
    [self fetchUsers];
}

- (IBAction)onTapProfilePicture:(id)sender {
    if(self.currentUser != [PFUser currentUser]){
        return;
    }
    else{
        [Utility showImageTakeOptionSheetOnViewController:self withTitleString:ADDPROFILEPHOTO];
    }
}

-(void)fetchUser{
    PFQuery *userQuery = [PFQuery queryWithClassName:USERCLASS];
    [userQuery includeKey:PARTIESATTENDEDKEY];
    [userQuery getObjectInBackgroundWithId:[self.currentUser objectId] block:^(PFObject *user, NSError *error) {
        if(!error){
            self.profilePicture.file = user[USERPROFILEPHOTOKEY];
            self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
            self.profilePicture.layer.borderWidth= BORDERWIDTH;
            [self.profilePicture loadInBackground];
            self.usernameLabel.text = user[USERUSERNAMEKEY];
            self.partiesAttendedLabel.text = [NSString stringWithFormat:@"%@", user[PARTIESATTENDEDKEY]];
        }
        else{
            NSLog(ERRORTEXTFORMAT, error.localizedDescription);
        }
    }];
}

-(void)fetchUsers{
    PFQuery *userQuery = [PFQuery queryWithClassName:USERCLASS];
    [userQuery includeKey:PARTIESATTENDEDKEY];
    [userQuery whereKey:USERISTHROWERKEY equalTo:NOKEYWORD];
    [userQuery orderByDescending:PARTIESATTENDEDKEY];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        if(!error){
            self.users = (NSMutableArray *) users;
            [self.profileTableView reloadData];
        }
    }];
}

-(void)fetchAttendedParties{
    PFQuery *partyQuery = [PFQuery queryWithClassName:CHECKINCLASS];
    [partyQuery whereKey:USER equalTo:self.currentUser];
    [partyQuery includeKey:PARTYKEY];
    [partyQuery orderByDescending:CREATEDAT];
    [partyQuery findObjectsInBackgroundWithBlock:^(NSArray *checkIns, NSError *error) {
            if(!error)
            {
                self.partiesAttended = (NSMutableArray *) checkIns;
                [self.seenPartiesTableView reloadData];
            }
            else
                NSLog(ERRORTEXTFORMAT, error.localizedDescription);
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self.profilePicture setImage:[Utility resizeImage:editedImage withSize:CGSizeMake(IMAGERESIZECONSTANT, IMAGERESIZECONSTANT)]];
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
            profileImageExpand.view.layer.cornerRadius = profileImageExpand.view.frame.size.height/IMAGECORNERRADIUS;
            profileImageExpand.view.layer.zPosition = MAXFLOAT;
            profileImageExpand.view.transform = CGAffineTransformScale(translateCenter, SIZEMULTIPLIER, SIZEMULTIPLIER);
        } completion:nil];
    }
    if(profileImageExpand.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:DEFAULTDURATION animations:^{
            profileImageExpand.view.layer.cornerRadius = profileImageExpand.view.frame.size.height/5;
            profileImageExpand.view.transform = CGAffineTransformIdentity;
        } completion:nil];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *profileCell;
    if(tableView == self.seenPartiesTableView){
        AttendedPartyCell *attendedPartyCell = [self.seenPartiesTableView dequeueReusableCellWithIdentifier:ATTENDEDPARTYCELL];
        attendedPartyCell.layer.cornerRadius = CELLCORNERRADIUS;
        attendedPartyCell.layer.borderWidth = BORDERWIDTH;
        Check_In *checkIn = self.partiesAttended[indexPath.section];
        Party *party = checkIn.party;
        attendedPartyCell.partyNameLabel.text = party.name;
        attendedPartyCell.partyThemeLabel.text= party.partyDescription;
        attendedPartyCell.throwerProfilePicture.layer.borderWidth = BORDERWIDTH;
        attendedPartyCell.throwerProfilePicture.layer.cornerRadius = attendedPartyCell.throwerProfilePicture.frame.size.height/2;
        attendedPartyCell.partyRatingLabel.text = [NSString stringWithFormat:ATTENDEDPARTYRATINGFORMAT, party.rating];
        PFQuery *throwerQuery = [PFQuery queryWithClassName:THROWERCLASS];
        [throwerQuery includeKey:THROWERKEY];
        [throwerQuery whereKey:THROWERKEY equalTo:party.partyThrower];
        [throwerQuery getFirstObjectInBackgroundWithBlock:^(PFObject * thrower, NSError * error) {
            if(!error){
                attendedPartyCell.throwerProfilePicture.file = thrower[THROWERKEY][USERPROFILEPHOTOKEY];
                [attendedPartyCell.throwerProfilePicture loadInBackground];
                attendedPartyCell.throwerNameLabel.text = [NSString stringWithFormat:OBJECTTEXTAFTERPERIOD, thrower[THROWERNAMEKEY]];
            }
            else
                NSLog(@"%@", error.localizedDescription);
        }];
        if([party.endTime laterDate:[NSDate now]] == party.endTime)
            attendedPartyCell.partyTimeLabel.text = NOW;
        else
            attendedPartyCell.partyTimeLabel.text = [NSString stringWithFormat:OBJECTTEXTAFTERPERIOD, [NSDate shortTimeAgoSinceDate:party.startTime]];
        [self partyHeadCountQuery:party withAttendedPartyCell:attendedPartyCell];
        profileCell = attendedPartyCell;
    }
    
    if(tableView == self.profileTableView){
        PartyBoardCell *partyBoardCell = [self.profileTableView dequeueReusableCellWithIdentifier:RANKCELL];
        PFUser *user = self.users[indexPath.section];
        
        if([user[USERUSERNAMEKEY] isEqualToString:[PFUser currentUser][USERUSERNAMEKEY]]){
            partyBoardCell.usernameLabel.font = [UIFont systemFontOfSize:FONTSIZEFORUSERNAME weight:UIFontWeightSemibold];
            partyBoardCell.userPartiesAttendedLabel.font = [UIFont systemFontOfSize:FONTSIZEFORUSERNAME weight:UIFontWeightSemibold];
            partyBoardCell.userRankLabel.font = [UIFont systemFontOfSize:FONTSIZEFORUSERNAME weight:UIFontWeightSemibold];
            partyBoardCell.usernameLabel.text = YOU;
        }
        else
            partyBoardCell.usernameLabel.text = user[USERUSERNAMEKEY];
        partyBoardCell.userRankLabel.text = [NSString stringWithFormat:@"%ld. ", (long)indexPath.section + 1];
        partyBoardCell.userPartiesAttendedLabel.text = [NSString stringWithFormat:@"%@", user[PARTIESATTENDEDKEY]];
        partyBoardCell.userProfilePhotoView.layer.cornerRadius = partyBoardCell.userProfilePhotoView.frame.size.height / 2;
        partyBoardCell.userProfilePhotoView.layer.borderWidth = BORDERWIDTH;
        partyBoardCell.userProfilePhotoView.file = user[USERPROFILEPHOTOKEY];
        [partyBoardCell.userProfilePhotoView loadInBackground];
        profileCell = partyBoardCell;
    }
    return profileCell;
}

-(void)partyHeadCountQuery:(Party *) party withAttendedPartyCell:(AttendedPartyCell *) attendedPartyCell{
    PFQuery *headCountQuery = [PFQuery queryWithClassName:CHECKINCLASS];
    [headCountQuery whereKey:PARTYKEY equalTo:party];
    [headCountQuery countObjectsInBackgroundWithBlock:^(int number, NSError * error) {
        attendedPartyCell.partyHeadCountLabel.text = [NSString stringWithFormat:HEADCOUNTTEXT, number];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUMBEROFROWSINSECTION;
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
    return FOOTERHEIGHTCONSTANT;
}

- (IBAction)didChangeSegment:(id)sender {
    UISegmentedControl *profileSegmentedControl = sender;
    switch (profileSegmentedControl.selectedSegmentIndex) {
        case 0:{
            [UIView animateWithDuration:DEFAULTDURATION animations:^{
                self.seenPartiesTableView.transform = CGAffineTransformMakeTranslation(ORIGINALXPOSITION, ORIGINALYPOSITION);
                self.profileTableView.transform = CGAffineTransformMakeTranslation(ORIGINALXPOSITION, ORIGINALYPOSITION);
            } completion:nil];
            break;
        }
        case 1:{
            [UIView animateWithDuration:DEFAULTDURATION animations:^{
                self.profileTableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, ORIGINALYPOSITION);
                self.seenPartiesTableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, ORIGINALYPOSITION);
            } completion:nil];
            break;
        }
        default:
            break;
    }
}
@end
