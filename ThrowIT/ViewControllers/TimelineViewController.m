//
//  TimelineViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/5/22.
//


#import "TimelineViewController.h"
#import "DetailsViewController.h"
#import "CoreHapticsGenerator.h"
#import "SceneDelegate.h"
#import "partyCell.h"
#import "TopPartyCell.h"
#import "Attendance.h"
#import "Party.h"
#import "Thrower.h"
#import <Parse/Parse.h>
#import "DateTools.h"
#import "Errorhandler.h"


@interface TimelineViewController () <PartyFilterViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *topPartyCellSizes;
@property (nonatomic, strong) NSMutableArray *partyList;
@property (nonatomic, strong) NSMutableArray *filteredList;
@property (nonatomic, strong) NSMutableArray *distanceDetailsList;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic)int goingListCount;
@property (nonatomic)int tapCount;
@property (nonatomic, strong) CoreHapticsGenerator *soundGenerator;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.soundGenerator = [CoreHapticsGenerator initWithEngineOnViewController:self];
    [[APIManager shared] locationManagerInit];
    [self fetchParties];
    [self setUpcollectionViewWithCHTCollectionViewWaterfallLayout];
    self.topPartyCellSizes = @[
    [NSValue valueWithCGSize:CGSizeMake(self.collectionView.frame.size.width/2.0, self.collectionView.frame.size.height)],
    [NSValue valueWithCGSize:CGSizeMake(self.collectionView.frame.size.width/2.0, self.collectionView.frame.size.height*0.66 - COLLECTIONVIEWBORDER)],
    [NSValue valueWithCGSize:CGSizeMake(self.collectionView.frame.size.width/2.0, self.collectionView.frame.size.height*0.34 - COLLECTIONVIEWBORDER)],
    ];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 120;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchParties) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}
- (IBAction)logoutUser:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (!error)
        {
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN bundle:nil];
            UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier: LOGINVIEWCONTROLLER];
            sceneDelegate.window.rootViewController = loginViewController;
        }
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:DETAILSVIEWCONTROLLERFORCOLLECTIONCELL]){
        UICollectionViewCell *partyCell = sender;
        NSIndexPath *myIndexPath = [self.collectionView indexPathForCell:partyCell];
        Party *party = self.filteredList[myIndexPath.item];
        DetailsViewController *detailsController = [segue destinationViewController];
        detailsController.party = party;
        detailsController.delegate = (id) self;
    }
    else if([[segue identifier] isEqualToString:DETAILSVIEWCONTROLLERFORTABLECELL]){
        UITableViewCell *partyCell = sender;
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:partyCell];
        Party *party = self.filteredList[myIndexPath.section + SHIFTNUMBER];
        DetailsViewController *detailsController = [segue destinationViewController];
        detailsController.party = party;
        detailsController.delegate = (id) self;
    }
    else if([[segue identifier] isEqualToString:FILTERSEGUE]){
        UINavigationController *partyFilterNavigationController = [segue destinationViewController];
        PartyFilterViewController *partyFilterViewController = [partyFilterNavigationController.viewControllers objectAtIndex:0];
        partyFilterViewController.delegate = self;
    }
}

-(void)fetchParties{
    PFQuery *query = [PFQuery queryWithClassName:PARTYCLASS];
    [query orderByDescending:CREATEDAT];
    [query whereKey:ENDTIME greaterThan:[NSDate now]];
    [query includeKey:PARTYTHROWERKEY];
    query.limit = QUERYLIMIT;
    [query findObjectsInBackgroundWithBlock:^(NSArray  *partyList, NSError *error) {
        if (!error){
            self.partyList = (NSMutableArray *)partyList;
            if(self.distanceDetailsList.count != partyList.count){
                self.distanceDetailsList = [Utility getDistancesFromArray:self.partyList withCompletionHandler:^(BOOL success) {
                    if(success){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self filterListByDistance:DISTANCELIMITDEFAULT byPartyCount:PARTYCOUNTLIMITDEFAULT byRating:RATINGLIMITDEFAULT ];
                        });
                    }
                }];
            }
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
            [self.collectionView reloadData];
        }
        else{
            [[ErrorHandler shared] showNetworkErrorMessageOnViewController:self withCompletion:^(BOOL tryAgain) {
                if(tryAgain)
                   [self fetchParties];
            }];
        }
    }];
}

-(void)filterListByDistance:(double)distance byPartyCount:(int)partyCount byRating:(double)rating{
    [Utility addDistanceDataToList:self.partyList fromList:self.distanceDetailsList];
    self.filteredList = [Utility getFilteredListFromList:self.partyList withDistanceLimit:distance withPartyCountlimit:partyCount withRatingLimit:rating withCompletionHandler:^(BOOL success) {
        if(success){
            [self.tableView reloadData];
            [self.collectionView reloadData];
        }
    }];
}

-(void)reloadCells{
    [self.collectionView reloadData];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PartyCell *partyCell = [self.tableView dequeueReusableCellWithIdentifier:PARTYCELL];
    partyCell.layer.cornerRadius = CELLCORNERRADIUS;
    partyCell.soundGenerator = self.soundGenerator;
    Party *party = self.filteredList[indexPath.section + SHIFTNUMBER];
    if(party.distancesFromUser != nil)
        partyCell.partyDistance.text = [NSString stringWithFormat:@". %@", party.distancesFromUser ];
    else
        partyCell.partyDistance.text = PARTYDISTANCELABELPLACEHOLDER;
    
    partyCell.partyName.text = party.name;
    partyCell.partyDescription.text= party.partyDescription;
    partyCell.throwerNameLabel.text = [NSString stringWithFormat:@". %@", party.partyThrower[USERUSERNAMEKEY]];
    partyCell.throwerProfilePicture.layer.borderWidth = 0.1;
    partyCell.throwerProfilePicture.layer.cornerRadius = partyCell.throwerProfilePicture.frame.size.height/2;
    PFQuery *throwerQuery = [PFQuery queryWithClassName:THROWERCLASS];
    [throwerQuery includeKey:THROWERKEY];
    [throwerQuery whereKey:THROWERKEY equalTo:party.partyThrower];
    [throwerQuery getFirstObjectInBackgroundWithBlock:^(PFObject * thrower, NSError * error) {
        if(!error){
            partyCell.partyRating.text = [NSString stringWithFormat:PARTYCELLPARTYRATINGTEXTFORMAT, thrower[THROWERRATING]];
            partyCell.throwerProfilePicture.file = thrower[THROWERKEY][USERPROFILEPHOTOKEY];
            [partyCell.throwerProfilePicture loadInBackground];
        }
        else
            NSLog(ERRORTEXTFORMAT, error.localizedDescription);
    }];
    if([party.startTime earlierDate:[NSDate now]] == party.startTime)
        partyCell.partyTime.text = NOW;
    else
        partyCell.partyTime.text = [NSString stringWithFormat:PARTYCELLPARTTIMETEXTFORMAT, [NSDate shortTimeAgoSinceDate:party.startTime]];
    PFQuery *goingQuery = [PFQuery queryWithClassName:ATTENDANCECLASS];
    [goingQuery whereKey:PARTYKEY equalTo:party];
    [goingQuery whereKey:USER equalTo:[PFUser currentUser]];
    [goingQuery findObjectsInBackgroundWithBlock:^(NSArray  *attendanceList, NSError *error) {
        if (!error){
            Attendance *attendance;
            if(!attendanceList.count){
                [partyCell.goingButton setTitle:NOTGOING forState:UIControlStateNormal];
            }
            else{
                attendance = attendanceList[0];
                if([attendance.attendanceType isEqualToString:GOING]){
                    [partyCell.goingButton setTitle:GOING forState:UIControlStateNormal];
                }
                else{
                    [partyCell.goingButton setTitle:MAYBE forState:UIControlStateNormal];
                }
            }
        }
        else{
            NSLog(ERRORTEXTFORMAT, error.localizedDescription);
        }
    }];
    [Check_In userIsCheckedIn:party withCompletion:^(BOOL checkInExists) {
        if(checkInExists)
            partyCell.checkInTag.hidden = false;
        else
            partyCell.checkInTag.hidden = true;
    }];
    [self partyGoingCountQuery:party withPartyCell:partyCell orWithTopPartyCell:nil];
    return partyCell;
}

-(void)partyGoingCountQuery:(Party *) party withPartyCell: (PartyCell * _Nullable) partyCell orWithTopPartyCell:(TopPartyCell * _Nullable) topPartyCell{
    PFQuery *partyQuery = [PFQuery queryWithClassName:(ATTENDANCECLASS)];
    [partyQuery whereKey:PARTYKEY equalTo:party];
    [partyQuery whereKey:ATTENDANCETYPEKEY equalTo:GOING];
    [partyQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable partyGoingList, NSError * _Nullable error) {
        party.numberAttending = (int)partyGoingList.count;
        [party saveInBackground];
        if(partyCell != nil){
            partyCell.partyGoingCount.text = [NSString stringWithFormat:@"%ld", (long)party.numberAttending];
            partyCell.party = party;
            }
        else if(topPartyCell != nil){
            topPartyCell.goingCountLabel.text = [NSString stringWithFormat:@"%ld", (long)party.numberAttending];
            topPartyCell.topParty = party;
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUMBEROFROWSINSECTION;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.filteredList.count > SHIFTNUMBER)
        return self.filteredList.count - SHIFTNUMBER;
    else
        return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return SPACE;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return FOOTERHEIGHTCONSTANT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tapCount++;
    switch (self.tapCount) {
        case 1: //single tap
            [self performSelector:@selector(singleTapOnTCell:) withObject:indexPath afterDelay: .4];
            break;
        case 2: //double tap
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapOnTCell:) object:indexPath];
            [self doubleTapOnTCell:indexPath];
            break;
        default:
            break;
    }
}

- (void)singleTapOnTCell:(NSIndexPath *)indexPath {
    PartyCell *partyCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self performSegueWithIdentifier:DETAILSVIEWCONTROLLERFORTABLECELL sender:partyCell];
    self.tapCount = 0;
}

- (void)doubleTapOnTCell:(NSIndexPath *)indexPath {
    PartyCell *partyCell = [self.tableView cellForRowAtIndexPath:indexPath];
    [partyCell didTapLike:partyCell.goingButton];
    self.tapCount = 0;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(self.filteredList.count < SHIFTNUMBER)
        return self.filteredList.count;
    else
        return SHIFTNUMBER;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopPartyCell *topPartyCell =
    [self.collectionView dequeueReusableCellWithReuseIdentifier:TOPPARTYCELL forIndexPath:indexPath];
    topPartyCell.layer.cornerRadius = CELLCORNERRADIUS;
    Party *party = self.filteredList[indexPath.item];
    CoreHapticsGenerator *soundGenerator = [CoreHapticsGenerator initWithEngineOnViewController:self];
    topPartyCell.soundGenerator = soundGenerator;
    topPartyCell.partyNameLabel.text = party.name;
    topPartyCell.partyDescriptionLabel.text = party.partyDescription;
    topPartyCell.throwerProfilePicture.layer.borderWidth = BORDERWIDTH;
    topPartyCell.throwerProfilePicture.layer.cornerRadius = topPartyCell.throwerProfilePicture.frame.size.height/2;
    PFQuery *throwerQuery = [PFQuery queryWithClassName:THROWERCLASS];
    [throwerQuery includeKey:THROWERKEY];
    [throwerQuery whereKey:THROWERKEY equalTo:party.partyThrower];
    [throwerQuery getFirstObjectInBackgroundWithBlock:^(PFObject * thrower, NSError * error) {
        if(!error){
            topPartyCell.partyRatingLabel.text = [NSString stringWithFormat:TOPPARTYCELLPARTYRATINGTEXTFORMAT, thrower[THROWERRATING]];
            topPartyCell.throwerProfilePicture.file = thrower[THROWERKEY][USERPROFILEPHOTOKEY];
            [topPartyCell.throwerProfilePicture loadInBackground];
        }
        else
            NSLog(ERRORTEXTFORMAT, error.localizedDescription);
    }];
    PFQuery *goingQuery = [PFQuery queryWithClassName:ATTENDANCECLASS];
    [goingQuery whereKey:PARTYKEY equalTo:party];
    [goingQuery whereKey:USER equalTo:[PFUser currentUser]];
    [goingQuery findObjectsInBackgroundWithBlock:^(NSArray  *attendanceList, NSError *error) {
        if (!error){
            Attendance *attendance;
            if(!attendanceList.count){
                [topPartyCell.goingButton setTitle:NOTGOING forState:UIControlStateNormal];
            }
            else{
                attendance = attendanceList[0];
                if([attendance.attendanceType isEqualToString:GOING]){
                    [topPartyCell.goingButton setTitle:GOING forState:UIControlStateNormal];
                }
                else{
                    [topPartyCell.goingButton setTitle:MAYBE forState:UIControlStateNormal];
                }
            }
        }
        else{
            NSLog(ERRORTEXTFORMAT, error.localizedDescription);
        }
    }];
    [Check_In userIsCheckedIn:party withCompletion:^(BOOL checkInExists) {
        if(checkInExists)
            topPartyCell.checkInTag.hidden = false;
        else
            topPartyCell.checkInTag.hidden = true;
    }];
    [self partyGoingCountQuery:party withPartyCell:nil orWithTopPartyCell:topPartyCell];
    return topPartyCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.tapCount++;
    switch (self.tapCount) {
        case 1: //single tap
            [self performSelector:@selector(singleTapOnCCell:) withObject:indexPath afterDelay: .4];
            break;
        case 2: //double tap
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapOnCCell:) object:indexPath];
            [self doubleTapOnCCell:indexPath];
            break;
        default:
            break;
    }
}

- (void)singleTapOnCCell:(NSIndexPath *)indexPath {
    TopPartyCell *topPartyCell = (TopPartyCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self performSegueWithIdentifier:DETAILSVIEWCONTROLLERFORCOLLECTIONCELL sender:topPartyCell];
    self.tapCount = 0;
}

- (void)doubleTapOnCCell:(NSIndexPath *)indexPath {
    TopPartyCell *topPartyCell = (TopPartyCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [topPartyCell didTapLike:topPartyCell.goingButton];
    self.tapCount = 0;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

-(void)setUpcollectionViewWithCHTCollectionViewWaterfallLayout{
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.minimumColumnSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.columnCount = 2;
    self.collectionView.collectionViewLayout = layout;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.topPartyCellSizes[indexPath.item] CGSizeValue];
}
@end
