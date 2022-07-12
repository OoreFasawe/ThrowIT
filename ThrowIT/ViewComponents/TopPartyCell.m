//
//  TopPartyCell.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/7/22.
//

#import "TopPartyCell.h"
#import "Attendance.h"

@implementation TopPartyCell

- (IBAction)didTapLike:(id)sender {
    [Attendance setAvailability:self.topParty withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
    }];
    if([self.goingButton.titleLabel.text isEqualToString:@"Going"]){
        [self.goingButton setTitle:@"Maybe" forState:UIControlStateNormal];
    }
    else if([self.goingButton.titleLabel.text isEqualToString:@"Maybe"]){
        [self.goingButton setTitle:@"Not going" forState:UIControlStateNormal];
    }
    else{
        [self.goingButton setTitle:@"Going" forState:UIControlStateNormal];
    }
}

@end
