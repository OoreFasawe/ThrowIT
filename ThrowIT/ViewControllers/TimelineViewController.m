//
//  TimelineViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/5/22.
//


#import "TimelineViewController.h"
#import "DetailsViewController.h"
#import "SceneDelegate.h"
#import "partyCell.h"
#import "TopPartyCell.h"
#import "Attendance.h"
#import "Party.h"
#import "Thrower.h"
#import <Parse/Parse.h>


@interface TimelineViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *topPartyCellSizes;
@property (nonatomic, strong) NSMutableArray *partyList;
@property (nonatomic, strong) NSMutableArray *distanceDetailsList;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic)int goingListCount;
@property (nonatomic)int tapCount;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[APIManager shared] locationManagerInit];
    [self fetchParties];
    [self setUpcollectionViewWithCHTCollectionViewWaterfallLayout];
    self.topPartyCellSizes = @[
    [NSValue valueWithCGSize:CGSizeMake(self.collectionView.frame.size.width/2.0, self.collectionView.frame.size.height)],
    [NSValue valueWithCGSize:CGSizeMake(self.collectionView.frame.size.width/2.0, self.collectionView.frame.size.height*0.66 - 2.5)],
    [NSValue valueWithCGSize:CGSizeMake(self.collectionView.frame.size.width/2.0, self.collectionView.frame.size.height*0.34 - 2.5)],
    ];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 120;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchParties) forControlEvents:UIControlEventValueChanged];
    self.refreshControl.layer.backgroundColor = [[UIColor whiteColor] CGColor];
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
        // Pass the selected object to the new view controller.
        Party *party = self.partyList[myIndexPath.item];
        DetailsViewController *detailsController = [segue destinationViewController];
        detailsController.party = party;
    }
    else if([[segue identifier] isEqualToString:DETAILSVIEWCONTROLLERFORTABLECELL]){
        UITableViewCell *partyCell = sender;
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:partyCell];
        // Pass the selected object to the new view controller.
        Party *party = self.partyList[myIndexPath.row + SHIFTNUMBER];
        DetailsViewController *detailsController = [segue destinationViewController];
        detailsController.party = party;
    }
}

-(void)fetchParties{

    PFQuery *query = [PFQuery queryWithClassName:PARTYCLASS];
    [query orderByDescending:CREATEDAT];
    [query includeKey:PARTYTHROWERKEY];
    query.limit = QUERYLIMIT;
    [query findObjectsInBackgroundWithBlock:^(NSArray  *partyList, NSError *error) {
        if (!error){
            self.partyList = (NSMutableArray *)partyList;
            if(self.distanceDetailsList.count != self.partyList.count){
                self.distanceDetailsList = [Utility getDistancesFromArray:self.partyList withCompletionHandler:^(BOOL success) {
                    if(success){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }}];
            }
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
            [self.collectionView reloadData];
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)partyDistancesFetched{
    [self.tableView reloadData];
};

#pragma mark - UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PartyCell *partyCell = [self.tableView dequeueReusableCellWithIdentifier:PARTYCELL];
    Party *party = self.partyList[indexPath.row + SHIFTNUMBER];
    if(self.distanceDetailsList.count)
        partyCell.partyDistance.text = [NSString stringWithFormat:@". %@", self.distanceDetailsList[indexPath.row + SHIFTNUMBER]];
    else
        partyCell.partyDistance.text = @" ...";
    partyCell.partyName.text = party.name;
    partyCell.partyDescription.text= party.partyDescription;
    partyCell.throwerNameLabel.text = [NSString stringWithFormat:@". %@", party.partyThrower[USERUSERNAMEKEY]];
    PFQuery *throwerQuery = [PFQuery queryWithClassName:THROWERCLASS];
    [throwerQuery whereKey:THROWERKEY equalTo:party.partyThrower];
    [throwerQuery getFirstObjectInBackgroundWithBlock:^(PFObject * thrower, NSError * error) {
        if(!error)
            partyCell.partyRating.text = [NSString stringWithFormat:PARTYCELLPARTYRATINGTEXTFORMAT, thrower[THROWERRATING]];
        else
            NSLog(@"%@", error.localizedDescription);
    }];
    partyCell.partyRating.text = [NSString stringWithFormat:@"%d", party.rating];
    partyCell.partyDescription.text= party.partyDescription; 
    PFQuery *goingQuery = [PFQuery queryWithClassName:ATTENDANCECLASS];
    [goingQuery whereKey:PARTYKEY equalTo:party];
    [goingQuery whereKey:USER equalTo:[PFUser currentUser]];
    [goingQuery findObjectsInBackgroundWithBlock:^(NSArray  *attendanceList, NSError *error) {
        if (!error){
            Attendance *attendance;
            //if there's not an attendance object, create one
            if(!attendanceList.count){
                [partyCell.goingButton setTitle:NOTGOING forState:UIControlStateNormal];
            }
            //if there's an attendance object, check it's attendance type
            else{
                attendance = attendanceList[0];
                //if attendancetype is going, change to maybe, if type is maybe, delete;
                if([attendance.attendanceType isEqualToString:GOING]){
                    [partyCell.goingButton setTitle:GOING forState:UIControlStateNormal];
                }
                else{
                    [partyCell.goingButton setTitle:MAYBE forState:UIControlStateNormal];
                }
            }
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self partyGoingCountQuery:party withPartyCell:partyCell];
    return partyCell;
}

-(void)partyGoingCountQuery:(Party *) party withPartyCell: (PartyCell *) partyCell{
    PFQuery *partyQuery = [PFQuery queryWithClassName:(ATTENDANCECLASS)];
    [partyQuery whereKey:PARTYKEY equalTo:party];
    [partyQuery whereKey:ATTENDANCETYPEKEY equalTo:GOING];
    [partyQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable partyGoingList, NSError * _Nullable error) {
        party.numberAttending = (int)partyGoingList.count;
        [party saveInBackground];
        partyCell.partyGoingCount.text = [NSString stringWithFormat:@"%ld", (long)party.numberAttending];
        partyCell.party = party;
    }];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.partyList.count - SHIFTNUMBER;
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
  return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TopPartyCell *topPartyCell =
    [self.collectionView dequeueReusableCellWithReuseIdentifier:TOPPARTYCELL forIndexPath:indexPath];
    topPartyCell.layer.cornerRadius = 10;
    Party *party = self.partyList[indexPath.item];
    
    topPartyCell.partyNameLabel.text = party.name;
    topPartyCell.partyDescriptionLabel.text = party.partyDescription;
    
    if(party){
        PFQuery *goingQuery = [PFQuery queryWithClassName:ATTENDANCECLASS];
        [goingQuery whereKey:PARTYKEY equalTo:party];
        [goingQuery whereKey:USER equalTo:[PFUser currentUser]];
        [goingQuery findObjectsInBackgroundWithBlock:^(NSArray  *attendanceList, NSError *error) {
            if (!error){
                Attendance *attendance;
                //if there's not attendance object, create one
                if(!attendanceList.count){
                    [topPartyCell.goingButton setTitle:NOTGOING forState:UIControlStateNormal];
                }
                //if there's an attendance object, check it's attendance type
                else{
                    attendance = attendanceList[0];

                    //if attendancetype is going, change to maybe, if maybe delete;
                    if([attendance.attendanceType isEqualToString:GOING]){
                        [topPartyCell.goingButton setTitle:GOING forState:UIControlStateNormal];
                    }
                    else{
                        [topPartyCell.goingButton setTitle:MAYBE forState:UIControlStateNormal];
                    }
                }
            }
            else{
                NSLog(@"%@", error.localizedDescription);
            }
            PFQuery *throwerQuery = [PFQuery queryWithClassName:THROWERCLASS];
            [throwerQuery whereKey:THROWERKEY equalTo:party.partyThrower];
            [throwerQuery getFirstObjectInBackgroundWithBlock:^(PFObject * thrower, NSError * error) {
                if(!error)
                    topPartyCell.partyRatingLabel.text = [NSString stringWithFormat:TOPPARTYCELLPARTYRATINGTEXTFORMAT, thrower[THROWERRATING]];
                else
                    NSLog(@"%@", error.localizedDescription);
            }];
        }];
    }
    topPartyCell.topParty = party;
    return topPartyCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
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
