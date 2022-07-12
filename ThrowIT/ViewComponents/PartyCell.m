//
//  PartyCell.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/6/22.
//

#import "PartyCell.h"
#import "Attendance.h"

@implementation PartyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapLike:(id)sender {
    [Attendance setAvailability:self.party withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
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
