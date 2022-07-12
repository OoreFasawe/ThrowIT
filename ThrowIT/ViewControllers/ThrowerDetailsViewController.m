//
//  ThrowerDetailsViewController.m
//  Pods
//
//  Created by Oore Fasawe on 7/12/22.
//

#import "ThrowerDetailsViewController.h"

@interface ThrowerDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *partyNameLabel;

@end

@implementation ThrowerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.partyNameLabel.text = self.party.name;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
