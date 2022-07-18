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
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    if([self.goingButton.titleLabel.text isEqualToString:@"Crash"]){
        [self.goingButton setTitle:@"Maybe" forState:UIControlStateNormal];
        self.topParty.numberAttending -= 1;
        [self.topParty saveInBackground];
        self.goingCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.topParty.numberAttending];
    }
    else if([self.goingButton.titleLabel.text isEqualToString:@"Maybe"]){
        [self.goingButton setTitle:@"Pass" forState:UIControlStateNormal];
    }
    else{
        [self.goingButton setTitle:@"Crash" forState:UIControlStateNormal];
        self.topParty.numberAttending += 1;
        
        [self.topParty saveInBackground];
        self.goingCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.topParty.numberAttending];
    }
}

@end
