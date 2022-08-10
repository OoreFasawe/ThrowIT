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
@property (strong, nonatomic) IBOutlet UITableView *throwerBoardTableView;
@property (strong, nonatomic) IBOutlet UITableView *thrownPartiesTableView;
@property (strong, nonatomic) IBOutlet UIView *throwerProfileView;
@property (strong, nonatomic) NSMutableArray *throwerList;
@property (strong, nonatomic) NSMutableArray *thrownPartiesList;
@end

@implementation ThrowerProfileViewController

- (void)viewDidLoad {
    self.throwerProfileImageView.layer.cornerRadius = self.throwerProfileImageView.frame.size.height/10;
    self.throwerProfileImageView.layer.borderWidth = BORDERWIDTH;
    self.throwerBoardTableView.delegate = self;
    self.throwerBoardTableView.dataSource = self;
    self.thrownPartiesTableView.delegate = self;
    self.thrownPartiesTableView.dataSource = self;
    [self fetchThrower];
    [self fetchThrowers];
    [self fetchThrownParties];
    [super viewDidLoad];
}

- (IBAction)chooseThrowerProfilePhoto:(id)sender {
    [Utility showImageTakeOptionSheetOnViewController:self withTitleString:ADDPROFILEPHOTO];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [self.throwerProfileImageView setImage:[Utility resizeImage:editedImage withSize:CGSizeMake(IMAGERESIZECONSTANT, IMAGERESIZECONSTANT)]];
    PFUser *user = [PFUser currentUser];
    user[USERPROFILEPHOTOKEY] = [Utility getPFFileFromImage:self.throwerProfileImageView.image];
    [user saveInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)fetchThrower{
    PFQuery *userQuery = [PFQuery queryWithClassName:USERCLASS];
    [userQuery getObjectInBackgroundWithId:[[PFUser currentUser] objectId] block:^(PFObject *user, NSError *error) {
        if(!error){
            self.throwerNameLabel.text = user[USERUSERNAMEKEY];
            self.throwerProfileImageView.file = user[USERPROFILEPHOTOKEY];
            [self.throwerProfileImageView loadInBackground];
        }
    }];
}

-(void)fetchThrowers{
    PFQuery *throwersQuery = [PFQuery queryWithClassName:USERCLASS];
    [throwersQuery whereKey:USERISTHROWERKEY equalTo:@YES];
    [throwersQuery findObjectsInBackgroundWithBlock:^(NSArray *throwers, NSError *error) {
        if(!error){
            self.throwerList = (NSMutableArray*) throwers;
            [self.throwerBoardTableView reloadData];
        }
        else
            NSLog(@"%@", error.localizedDescription);
    }];
}

-(void)fetchThrownParties{
    PFQuery *thrownPartyQuery = [PFQuery queryWithClassName:PARTYCLASS];
    [thrownPartyQuery whereKey:PARTYTHROWERKEY equalTo:[PFUser currentUser]];
    [thrownPartyQuery whereKey:ENDTIME lessThan:[NSDate now]];
    [thrownPartyQuery orderByDescending:ENDTIME];
    
    [thrownPartyQuery findObjectsInBackgroundWithBlock:^(NSArray * thrownParties, NSError *error) {
        if(!error){
            self.thrownPartiesList = (NSMutableArray *) thrownParties;
            [self.thrownPartiesTableView reloadData];
        }
        else
            NSLog(@"%@", error.localizedDescription);
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *profileCell;
    if(tableView == self.throwerBoardTableView){
        ThrowBoardCell *throwBoardCell = [self.throwerBoardTableView dequeueReusableCellWithIdentifier:THROWBOARDCELL];
        PFUser *user = self.throwerList[indexPath.section];
        
        if([user[USERUSERNAMEKEY] isEqualToString:[PFUser currentUser][USERUSERNAMEKEY]]){
            throwBoardCell.throwerNameLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
            throwBoardCell.thrownPartyCountLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
            throwBoardCell.throwerRankLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
            throwBoardCell.throwerNameLabel.text = YOU;
        }
        else
            throwBoardCell.throwerNameLabel.text = user[USERUSERNAMEKEY];
        throwBoardCell.throwerRankLabel.text = [NSString stringWithFormat:@"%ld. ", (long)indexPath.section + 1];
        throwBoardCell.throwerProfilePictureView.layer.cornerRadius = throwBoardCell.throwerProfilePictureView.frame.size.height / 2;
        throwBoardCell.throwerProfilePictureView.layer.borderWidth = BORDERWIDTH;
        throwBoardCell.throwerProfilePictureView.file = user[USERPROFILEPHOTOKEY];
        [throwBoardCell.throwerProfilePictureView loadInBackground];
        [self getPartyThrownCount:user forCell:throwBoardCell];
        profileCell = throwBoardCell;
    }
    
    if(tableView == self.thrownPartiesTableView){
        ThrownPartyCell *thrownPartyCell = [self.thrownPartiesTableView dequeueReusableCellWithIdentifier:THROWNPARTYCELL];
        Party *party = self.thrownPartiesList[indexPath.section];
        thrownPartyCell.layer.cornerRadius = CELLCORNERRADIUS;
        thrownPartyCell.thrownPartyImageView.layer.cornerRadius = IMAGECORNERRADIUS;
        thrownPartyCell.thrownPartyImageView.layer.borderWidth = BORDERWIDTH;
        thrownPartyCell.thrownPartyNameLabel.text = party.name;
        thrownPartyCell.partyThemeLabel.text = party.partyDescription;
        thrownPartyCell.partyRatingLabel.text = [NSString stringWithFormat:RATINGLABELTEXTFORMAT, (float)party.rating];
        thrownPartyCell.thrownPartyImageView.file = party.partyPhoto;
        if([party.endTime laterDate:[NSDate now]] == party.endTime)
            thrownPartyCell.thrownPartyTimeAgoLabel.text = NOW;
        else
            thrownPartyCell.thrownPartyTimeAgoLabel.text = [party.startTime shortTimeAgoSinceNow];
        [thrownPartyCell.thrownPartyImageView loadInBackground];
        [self partyHeadCountQuery:party withThrownPartyCell:thrownPartyCell];
        profileCell = thrownPartyCell;
    }
    return profileCell;
}

-(void)getPartyThrownCount:(PFUser *) user forCell:(ThrowBoardCell *) throwBoardCell{
    PFQuery *partyThrownQuery = [PFQuery queryWithClassName:PARTYCLASS];
    [partyThrownQuery whereKey:PARTYTHROWERKEY equalTo: user];
    [partyThrownQuery whereKey:ENDTIME lessThan:[NSDate now]];
    [partyThrownQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if(!error){
            throwBoardCell.thrownPartyCountLabel.text = [NSString stringWithFormat:@"%d", number];
            self.throwerPartiesThrownCount.text = [NSString stringWithFormat:PARTYTHROWNCOUNT, number];
        }
        else
            NSLog(@"%@", error.localizedDescription);
    }];
}

-(void)partyHeadCountQuery:(Party *) party withThrownPartyCell:(ThrownPartyCell *) thrownPartyCell{
    PFQuery *headCountQuery = [PFQuery queryWithClassName:CHECKINCLASS];
    [headCountQuery whereKey:PARTYKEY equalTo:party];
    [headCountQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        thrownPartyCell.partyHeadCountLabel.text = [NSString stringWithFormat:HEADCOUNTTEXT, number];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return FOOTERHEIGHTCONSTANT;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return SPACE;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return NUMBEROFROWSINSECTION;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger numberToReturn = 0;
    if(tableView == self.throwerBoardTableView)
        numberToReturn = self.throwerList.count;
    if(tableView == self.thrownPartiesTableView)
        numberToReturn = self.thrownPartiesList.count;
    return numberToReturn;
}

- (IBAction)didChangeSegment:(id)sender {
    UISegmentedControl *throwerProfileSegmentedControl = sender;
    switch (throwerProfileSegmentedControl.selectedSegmentIndex) {
        case 0:{
            [UIView animateWithDuration:DEFAULTDURATION animations:^{
            self.thrownPartiesTableView.transform = CGAffineTransformMakeTranslation(ORIGINALXPOSITION, ORIGINALYPOSITION);
            self.throwerBoardTableView.transform = CGAffineTransformMakeTranslation(ORIGINALXPOSITION, ORIGINALYPOSITION);
            self.throwerProfileView.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, ORIGINALYPOSITION);
            }completion:nil];
            break;
        }
        case 1:{
            [UIView animateWithDuration:DEFAULTDURATION animations:^{
                self.thrownPartiesTableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 1.f);
                self.throwerBoardTableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, ORIGINALYPOSITION);
                self.throwerProfileView.transform = CGAffineTransformMakeTranslation(ORIGINALXPOSITION, ORIGINALYPOSITION);
            } completion:nil];
            break;
        }
        case 2:{
            [UIView animateWithDuration:DEFAULTDURATION animations:^{
                self.thrownPartiesTableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width * 2, ORIGINALYPOSITION);
                self.throwerBoardTableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width * 2, ORIGINALYPOSITION);
                self.throwerProfileView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, ORIGINALYPOSITION);
            } completion:nil];
        }
        default:
            break;
    }
}

@end
