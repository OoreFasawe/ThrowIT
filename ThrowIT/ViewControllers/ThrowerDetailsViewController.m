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
    self.partyNameLabel.text = self.party.name;
}
@end
