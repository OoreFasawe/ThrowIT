//
//  SearchTabViewController.m
//  ThrowIT
//
//  Created by Ooreoluwa Fasawe on 28/08/2022.
//

#import "SearchTabViewController.h"
#import "SearchCell.h"
#import "Utility.h"

@interface SearchTabViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) NSMutableArray *usersArray;
@property (strong, nonatomic) NSMutableArray *filteredUsersArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end
@implementation SearchTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchBar.delegate = self;
    self.searchTableView.rowHeight = UITableViewAutomaticDimension;
    [self fetchSearchedUsers];
}

- (void)fetchSearchedUsers{
    PFQuery *usersQuery = [PFQuery queryWithClassName:@"_User"];
    [usersQuery whereKey:USERISTHROWERKEY equalTo:NOKEYWORD];
    [usersQuery findObjectsInBackgroundWithBlock:^(NSArray * users, NSError *error) {
        self.usersArray = (NSMutableArray *) users;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredUsersArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchCell *searchCell = [self.searchTableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    PFUser *user = self.filteredUsersArray[indexPath.row];
    searchCell.userProfilePhoto.file = user[USERPROFILEPHOTOKEY];
    [searchCell.userProfilePhoto loadInBackground];
    searchCell.userUserNameLabel.text = user[USERUSERNAMEKEY];
    return searchCell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.filteredUsersArray = [[NSMutableArray alloc] init];
    for (PFUser *user in self.usersArray) {
        NSRange range = [user[USERUSERNAMEKEY] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound)
            [self.filteredUsersArray addObject:user];
    }
    [self.searchTableView reloadData];
}
@end
