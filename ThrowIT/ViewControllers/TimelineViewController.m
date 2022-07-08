//
//  TimelineViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/5/22.
//

#import "TimelineViewController.h"
#import "SceneDelegate.h"
#import "partyCell.h"
#import "TopPartyCell.h"
#import "Party.h"
#import "Thrower.h"
#import <Parse/Parse.h>

@interface TimelineViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *topPartyCellSizes;

@end

@implementation TimelineViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
//    [Party postNewParty:@"Beta Vegas" withDescription:@"Best party on campus" withStartTime:nil withEndTime:nil withSchoolName:@"mySchool" withBackGroundImage:nil withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
//        if(!error){
//            NSLog(@"Party added to database successfully");
//        }
//        else{
//            NSLog(@"Try again, getting there");
//        }
//            
//    }];
//    
//    [Thrower postNewThrower:@"Beta" withSchool:@"mySchool" withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
//        if(!error){
//            NSLog(@"Thrower added to database successfully");
//        }
//        else{
//            NSLog(@"Try again, getting there");
//        }
//    }];
//    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PartyCell *partyCell = [self.tableView dequeueReusableCellWithIdentifier:@"PartyCell"];
    
    partyCell.partyName.text = @"Beta Vegas";
    partyCell.partyTime.text = @"5:00 pm";
    partyCell.partyGoingCount.text = @"100";
    partyCell.partyRating.text = @"5.0";
    
    return partyCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
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
  (TopPartyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TopPartyCell" forIndexPath:indexPath];
  
    topPartyCell.partyNameLabel.text = @"Beta Vegas";
    
  return topPartyCell;
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
