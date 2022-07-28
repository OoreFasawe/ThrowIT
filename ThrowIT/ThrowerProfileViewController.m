//
//  ThrowerProfileViewController.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/28/22.
//

#import "ThrowerProfileViewController.h"

@interface ThrowerProfileViewController ()
@property (strong, nonatomic) IBOutlet PFImageView *throwerProfileImageView;
@property (strong, nonatomic) IBOutlet UILabel *throwerPartiesThrownCount;
@property (strong, nonatomic) IBOutlet UISegmentedControl *throwerSegmentedController;
@end

@implementation ThrowerProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.throwerProfileImageView.layer.cornerRadius = self.throwerProfileImageView.frame.size.height/10;
    self.throwerProfileImageView.layer.borderWidth = 0.05;
}
@end
