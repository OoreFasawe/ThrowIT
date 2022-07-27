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
    if (self.soundGenerator != nil){
        [self.soundGenerator playAttendanceSound];
    }
    if([self.goingButton.titleLabel.text isEqualToString:GOING]){
        [self.goingButton setTitle:MAYBE forState:UIControlStateNormal];
        self.party.numberAttending -= 1;
        [self.party saveInBackground];
        self.partyGoingCount.text = [NSString stringWithFormat:@"%ld", (long)self.party.numberAttending];
    }
    else if([self.goingButton.titleLabel.text isEqualToString:MAYBE]){
        [self.goingButton setTitle:NOTGOING forState:UIControlStateNormal];
    }
    else{
        [self.goingButton setTitle:GOING forState:UIControlStateNormal];
        self.party.numberAttending += 1;
        [self.party saveInBackground];
        self.partyGoingCount.text = [NSString stringWithFormat:@"%ld", (long)self.party.numberAttending];
    }
}

@end
