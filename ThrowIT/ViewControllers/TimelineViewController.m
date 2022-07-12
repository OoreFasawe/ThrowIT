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
@property (strong,nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController




- (void)viewDidLoad {
    [super viewDidLoad];

    [self fetchThrowerParties];
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
    [self.refreshControl addTarget:self action:@selector(fetchThrowerParties) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
}
- (IBAction)logoutUser:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (!error)
        {
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            sceneDelegate.window.rootViewController = loginViewController;
        }
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"toDetailsViewControllerForCollectionCell"]){
        UICollectionViewCell *partyCell = sender;
        NSIndexPath *myIndexPath = [self.collectionView indexPathForCell:partyCell];
        // Pass the selected object to the new view controller.
        Party *party = self.partyList[myIndexPath.item];
        DetailsViewController *detailsController = [segue destinationViewController];
        detailsController.party = party;
    }
    else if([[segue identifier] isEqualToString:@"toDetailsViewControllerForTableCell"]){
        UITableViewCell *partyCell = sender;
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:partyCell];
        // Pass the selected object to the new view controller.
        Party *party = self.partyList[myIndexPath.row + 3];
        DetailsViewController *detailsController = [segue destinationViewController];
        detailsController.party = party;
    }
}


-(void)fetchThrowerParties{
    PFQuery *query = [PFQuery queryWithClassName:@"Party"];
    [query orderByDescending:@"createdAt"];
    query.limit = 20;

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
    PartyCell *partyCell = [self.tableView dequeueReusableCellWithIdentifier:@"PartyCell"];
    
    Party *party = self.partyList[indexPath.row + 3];
    
    
    partyCell.partyName.text = party.name;
    partyCell.partyTime.text = party.partyDescription;
    partyCell.partyGoingCount.text = [NSString stringWithFormat:@"%@", party.numberAttending];
    partyCell.partyRating.text = [NSString stringWithFormat:@"%d", party.rating];
    partyCell.partyDescription.text= party.partyDescription;

    
    PFQuery *goingQuery = [PFQuery queryWithClassName:@"Attendance"];
    [goingQuery whereKey:@"party" equalTo:party];
    [goingQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [goingQuery findObjectsInBackgroundWithBlock:^(NSArray  *attendanceList, NSError *error) {
        if (!error){
            Attendance *attendance;
            //if there's not attendance object, create one
            if(!attendanceList.count){
                [partyCell.goingButton setTitle:@"Not going" forState:UIControlStateNormal];
            }
            //if there's an attendance object, check it's attendance type
            else{
                attendance = attendanceList[0];
                
                //if attendancetype is going, change to maybe, if maybe delete;
                if([attendance.attendanceType isEqualToString:@"Going"]){
                    [partyCell.goingButton setTitle:@"Going" forState:UIControlStateNormal];
                }
                else{
                    [partyCell.goingButton setTitle:@"Maybe" forState:UIControlStateNormal];
                }
            }
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    partyCell.party = party;
    
    return partyCell;
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
    [self.collectionView dequeueReusableCellWithReuseIdentifier:@"TopPartyCell" forIndexPath:indexPath];
    Party *party = self.partyList[indexPath.item];
    
    topPartyCell.partyNameLabel.text = party.name;
    topPartyCell.partyDescriptionLabel.text = party.partyDescription;
    
    if(party){
        PFQuery *goingQuery = [PFQuery queryWithClassName:@"Attendance"];
        [goingQuery whereKey:@"party" equalTo:party];
        [goingQuery whereKey:@"user" equalTo:[PFUser currentUser]];
        [goingQuery findObjectsInBackgroundWithBlock:^(NSArray  *attendanceList, NSError *error) {
            if (!error){
                Attendance *attendance;
                //if there's not attendance object, create one
                if(!attendanceList.count){
                    [topPartyCell.goingButton setTitle:@"Not going" forState:UIControlStateNormal];
                }
                //if there's an attendance object, check it's attendance type
                else{
                    attendance = attendanceList[0];

                    //if attendancetype is going, change to maybe, if maybe delete;
                    if([attendance.attendanceType isEqualToString:@"Going"]){
                        [topPartyCell.goingButton setTitle:@"Going" forState:UIControlStateNormal];
                    }
                    else{
                        [topPartyCell.goingButton setTitle:@"Maybe" forState:UIControlStateNormal];
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

//        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//        layout.headerHeight = 15;
//        layout.footerHeight = 10;
    layout.minimumColumnSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.columnCount = 2;

    self.collectionView.collectionViewLayout = layout;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.topPartyCellSizes[indexPath.item] CGSizeValue];
}
@end
