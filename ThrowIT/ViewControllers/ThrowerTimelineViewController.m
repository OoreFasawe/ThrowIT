//
//  ThrowerTimelineViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/11/22.
//

#import "ThrowerTimelineViewController.h"
#import "ThrowerDetailsViewController.h"
#import "CreatePartyViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "ThrowerPartyCell.h"
#import "Party.h"
#import "Utility.h"

@interface ThrowerTimelineViewController () <UITableViewDelegate, UITableViewDataSource, CreatePartyViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *throwerPartyList;
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) int goingListCount;
@end

@implementation ThrowerTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self fetchThrowerParties];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchThrowerParties) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}
- (IBAction)logoutUser:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (!error)
        {
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN bundle:nil];
            UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:LOGINVIEWCONTROLLER];
            sceneDelegate.window.rootViewController = loginViewController;
        }
    }];
}

-(void)fetchThrowerParties{
    PFQuery *query = [PFQuery queryWithClassName:PARTYCLASS];
    [query orderByDescending:CREATEDAT];
    [query whereKey:PARTYTHROWERKEY equalTo:[PFUser currentUser]];
    [query whereKey:ENDTIME greaterThan:[NSDate now]];
    query.limit = QUERYLIMIT;
    [query findObjectsInBackgroundWithBlock:^(NSArray  *partyList, NSError *error) {
        if (!error){
            self.throwerPartyList = (NSMutableArray *)partyList;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
        else{
            NSLog(ERRORTEXTFORMAT, error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:CREATEPARTYSEGUE]){
        UINavigationController *navigationController = [segue destinationViewController];
        CreatePartyViewController *createPartyViewController = (CreatePartyViewController*)navigationController.topViewController;
        createPartyViewController.delegate = self;
    }
    else if([[segue identifier] isEqualToString:THROWERDETAILSVIEWCONTROLLER]){
        UITableViewCell *partyCell = sender;
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:partyCell];
        // Pass the selected object to the new view controller.
        Party *party = self.throwerPartyList[myIndexPath.section];
        ThrowerDetailsViewController *throwerDetailsController = [segue destinationViewController];
        throwerDetailsController.party = party;
    }
}
#pragma mark - Navigation end

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Party *party = self.throwerPartyList[indexPath.row];
        [party deleteInBackground];
        [self.throwerPartyList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else{
        NSLog(UNHANDLEDEDITINGSTYLE, (long)editingStyle);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return FOOTERHEIGHTCONSTANT;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ThrowerPartyCell *throwerPartyCell = [tableView dequeueReusableCellWithIdentifier:THROWERPARTYCELL];
    Party *party = self.throwerPartyList[indexPath.section];
    throwerPartyCell.partyName.text = party.name;
    throwerPartyCell.partyDescription.text = party.partyDescription;
    throwerPartyCell.layer.cornerRadius = CELLCORNERRADIUS;
    throwerPartyCell.layer.borderWidth = BORDERWIDTH;
    throwerPartyCell.partyImageView.layer.cornerRadius = IMAGECORNERRADIUS;
    throwerPartyCell.partyImageView.layer.borderWidth = BORDERWIDTH;
    if(party.partyPhoto == nil)
        [throwerPartyCell.partyImageView setImage:[UIImage imageNamed:PARTYIMAGEDEFAULT]];
    else{
        throwerPartyCell.partyImageView.file = party.partyPhoto;
        [throwerPartyCell.partyImageView loadInBackground];
    }
    [self partyGoingCountQuery:party withPartyCell:throwerPartyCell];
    return throwerPartyCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.throwerPartyList.count;
}

-(void)partyGoingCountQuery:(Party *) party withPartyCell: (ThrowerPartyCell *) throwerPartyCell{
    PFQuery *partyQuery = [PFQuery queryWithClassName:(ATTENDANCECLASS)];
    [partyQuery whereKey:PARTYKEY equalTo:party];
    [partyQuery whereKey:ATTENDANCETYPEKEY equalTo:GOING];
    [partyQuery findObjectsInBackgroundWithBlock:^(NSArray *partyGoingList, NSError *error) {
        party.numberAttending = (int)partyGoingList.count;
        throwerPartyCell.numberAttendingParty.text = [NSString stringWithFormat:THROWERPARTYCELLHEADCOUNTTEXTFORMAT, (long)party.numberAttending];
        throwerPartyCell.party = party;
        [party saveInBackground];
    }]; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUMBEROFROWSINSECTION;
}

- (void)didCreateParty:(Party *)party {
    [self.throwerPartyList insertObject:party atIndex:0];
    [self.tableView reloadData];
}
@end
