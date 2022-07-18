//
//  TimelineViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/5/22.
//

#import "Utility.h"
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
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic)int goingListCount;

@end

@implementation TimelineViewController




- (void)viewDidLoad {
    [super viewDidLoad];

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
        Party *party = self.partyList[myIndexPath.row + 3];
        DetailsViewController *detailsController = [segue destinationViewController];
        detailsController.party = party;
    }
}


-(void)fetchParties{
    PFQuery *query = [PFQuery queryWithClassName:PARTYCLASS];
    [query orderByDescending:CREATEDAT];
    query.limit = QUERYLIMIT;

    [query findObjectsInBackgroundWithBlock:^(NSArray  *partyList, NSError *error) {
        if (!error){
            self.partyList = (NSMutableArray *)partyList;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
            [self.collectionView reloadData];
            
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PartyCell *partyCell = [self.tableView dequeueReusableCellWithIdentifier:PARTYCELL];
    
    Party *party = self.partyList[indexPath.row + 3];
    
    partyCell.layer.cornerRadius = 10;
    partyCell.layer.borderWidth= 0.05;
    partyCell.partyName.text = party.name;
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
        partyCell.partyGoingCount.text = [NSString stringWithFormat:@"%d", party.numberAttending];
        
        partyCell.party = party;
    }];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.partyList.count - 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  TopPartyCell *topPartyCell =
    [self.collectionView dequeueReusableCellWithReuseIdentifier:TOPPARTYCELL forIndexPath:indexPath];
    topPartyCell.layer.cornerRadius = 10;
    topPartyCell.layer.borderWidth= 0.05;
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
