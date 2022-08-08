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
    self.throwerProfileImageView.layer.borderWidth = 0.05;
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
    [self.throwerProfileImageView setImage:[Utility resizeImage:editedImage withSize:CGSizeMake(500, 500)]];
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
    [thrownPartyQuery whereKey:@"endTime" lessThan:[NSDate now]];
    [thrownPartyQuery orderByDescending:@"endTime"];
    
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
        ThrowBoardCell *throwBoardCell = [self.throwerBoardTableView dequeueReusableCellWithIdentifier:@"ThrowBoardCell"];
        PFUser *user = self.throwerList[indexPath.section];
        
        if([user[USERUSERNAMEKEY] isEqualToString:[PFUser currentUser][USERUSERNAMEKEY]]){
            throwBoardCell.throwerNameLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
            throwBoardCell.thrownPartyCountLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
            throwBoardCell.throwerRankLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
            throwBoardCell.throwerNameLabel.text = @"You";
        }
        else
            throwBoardCell.throwerNameLabel.text = user[USERUSERNAMEKEY];
        throwBoardCell.throwerRankLabel.text = [NSString stringWithFormat:@"%ld. ", (long)indexPath.section + 1];
        throwBoardCell.throwerProfilePictureView.layer.cornerRadius = throwBoardCell.throwerProfilePictureView.frame.size.height / 2;
        throwBoardCell.throwerProfilePictureView.layer.borderWidth = 0.05;
        throwBoardCell.throwerProfilePictureView.file = user[USERPROFILEPHOTOKEY];
        [throwBoardCell.throwerProfilePictureView loadInBackground];
        [self getPartyThrownCount:user forCell:throwBoardCell];
        profileCell = throwBoardCell;
    }
    
    if(tableView == self.thrownPartiesTableView){
        ThrownPartyCell *thrownPartyCell = [self.thrownPartiesTableView dequeueReusableCellWithIdentifier:@"ThrownPartyCell"];
        Party *party = self.thrownPartiesList[indexPath.section];
        thrownPartyCell.layer.cornerRadius = 10;
        thrownPartyCell.thrownPartyImageView.layer.cornerRadius = 5;
        thrownPartyCell.thrownPartyImageView.layer.borderWidth = 0.05;
        thrownPartyCell.thrownPartyNameLabel.text = party.name;
        thrownPartyCell.partyThemeLabel.text = party.partyDescription;
        thrownPartyCell.partyRatingLabel.text = [NSString stringWithFormat:@"%.1f / 5", (float)party.rating];
        thrownPartyCell.thrownPartyImageView.file = party.partyPhoto;
        if([party.endTime laterDate:[NSDate now]] == party.endTime)
            thrownPartyCell.thrownPartyTimeAgoLabel.text = @". Now";
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
    [partyThrownQuery whereKey:@"endTime" lessThan:[NSDate now]];
    [partyThrownQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if(!error){
            throwBoardCell.thrownPartyCountLabel.text = [NSString stringWithFormat:@"%d", number];
            self.throwerPartiesThrownCount.text = [NSString stringWithFormat:@"Parties Thrown: %d", number];
        }
        else
            NSLog(@"%@", error.localizedDescription);
    }];
}

-(void)partyHeadCountQuery:(Party *) party withThrownPartyCell:(ThrownPartyCell *) thrownPartyCell{
    PFQuery *headCountQuery = [PFQuery queryWithClassName:@"Check_In"];
    [headCountQuery whereKey:PARTYKEY equalTo:party];
    [headCountQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        thrownPartyCell.partyHeadCountLabel.text = [NSString stringWithFormat:@"Headcount: %d", number];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return SPACE;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
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
    if(throwerProfileSegmentedControl.selectedSegmentIndex == 1){
        [UIView animateWithDuration:DEFAULTDURATION animations:^{
            self.thrownPartiesTableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 1.f);
            self.throwerBoardTableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 1.f);
            self.throwerProfileView.transform = CGAffineTransformMakeTranslation(1.f, 1.f);
        } completion:nil];
    }
    else if(throwerProfileSegmentedControl.selectedSegmentIndex == 2){
        [UIView animateWithDuration:DEFAULTDURATION animations:^{
            self.thrownPartiesTableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width * 2, 1.f);
            self.throwerBoardTableView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width * 2, 1.f);
            self.throwerProfileView.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 1.f);
        } completion:nil];
    }
    else{
        [UIView animateWithDuration:DEFAULTDURATION animations:^{
        self.thrownPartiesTableView.transform = CGAffineTransformMakeTranslation(1.f, 1.f);
        self.throwerBoardTableView.transform = CGAffineTransformMakeTranslation(1.f, 1.f);
        self.throwerProfileView.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 1.f);
        }completion:nil];
    }
}

@end
