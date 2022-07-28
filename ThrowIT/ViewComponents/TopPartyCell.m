//
//  TopPartyCell.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/7/22.
//

#import "TopPartyCell.h"
#import "Attendance.h"

@implementation TopPartyCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
}

- (IBAction)didTapLike:(id)sender {
    [Attendance setAvailability:self.topParty withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
    }];
    if (self.soundGenerator != nil){
        [self.soundGenerator playAttendanceSound];
    }
    if([self.goingButton.titleLabel.text isEqualToString:GOING]){
        [self.goingButton setTitle:MAYBE forState:UIControlStateNormal];
        self.topParty.numberAttending -= 1;
        [self.topParty saveInBackground];
        self.goingCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.topParty.numberAttending];
    }
    else if([self.goingButton.titleLabel.text isEqualToString:MAYBE]){
        [self.goingButton setTitle:NOTGOING forState:UIControlStateNormal];
    }
    else{
        [self.goingButton setTitle:GOING forState:UIControlStateNormal];
        self.topParty.numberAttending += 1;
        [self.topParty saveInBackground];
        self.goingCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.topParty.numberAttending];
    }
}

@end
