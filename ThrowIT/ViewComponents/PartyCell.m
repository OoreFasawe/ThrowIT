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
}
- (IBAction)didTapLike:(id)sender {
    [Attendance setAvailability:self.party withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
    }];
    if([self.goingButton.titleLabel.text isEqualToString:@"Going"]){
        [self.goingButton setTitle:@"Maybe" forState:UIControlStateNormal];
        self.party.numberAttending -= 1;
        [self.party saveInBackground];

        self.partyGoingCount.text = [NSString stringWithFormat:@"%d", self.party.numberAttending];
        
    }
    else if([self.goingButton.titleLabel.text isEqualToString:@"Maybe"]){
        [self.goingButton setTitle:@"Not going" forState:UIControlStateNormal];

    }
    else{
        [self.goingButton setTitle:@"Going" forState:UIControlStateNormal];
        self.party.numberAttending += 1;
        [self.party saveInBackground];
        self.partyGoingCount.text = [NSString stringWithFormat:@"%d", self.party.numberAttending];
    }
}

@end
