//
//  ThrowerTimelineViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/11/22.
//

#import "ThrowerTimelineViewController.h"
#import "CreatePartyViewController.h"
#import <Parse/Parse.h>
#import "SceneDelegate.h"
#import "ThrowerPartyCell.h"
#import "Party.h"

@interface ThrowerTimelineViewController () <UITableViewDelegate, UITableViewDataSource, CreatePartyViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *throwerPartyList;

@end

@implementation ThrowerTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 120;
    [self fetchThrowerParties];
    // Do any additional setup after loading the view.
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

-(void)fetchThrowerParties{
    PFQuery *query = [PFQuery queryWithClassName:@"Party"];
    [query whereKey:@"partyThrower" equalTo:[PFUser currentUser]];
    query.limit = 20;

    [query findObjectsInBackgroundWithBlock:^(NSArray  *partyList, NSError *error) {
        if (!error){
            self.throwerPartyList = (NSMutableArray *)partyList;
            [self.tableView reloadData];
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"createPartySegue"]){
    UINavigationController *navigationController = [segue destinationViewController];
    CreatePartyViewController *createPartyViewController = (CreatePartyViewController*)navigationController.topViewController;
    createPartyViewController.delegate = self;
    }
}
#pragma mark - Navigation end
 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ThrowerPartyCell *throwerPartyCell = [tableView dequeueReusableCellWithIdentifier:@"ThrowerPartyCell"];
    Party *party = self.throwerPartyList[indexPath.row];
    
    throwerPartyCell.partyName.text = party.name;
    throwerPartyCell.numberAttendingParty.text = [NSString stringWithFormat:@"%@", party.numberAttending];
    throwerPartyCell.partyDescription.text = party.partyDescription;
    
    return throwerPartyCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.throwerPartyList.count;
}

- (void)didCreateParty:(nonnull Party *)party {
    [self.throwerPartyList insertObject:party atIndex:0];
    [self.tableView reloadData];
}

@end
