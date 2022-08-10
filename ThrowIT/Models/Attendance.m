//
//  Attendance.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/12/22.
//

#import "Attendance.h"
#import "Utility.h"

@implementation Attendance
@dynamic party;
@dynamic user;
@dynamic attendanceType;

+ (nonnull NSString *)parseClassName {
    return ATTENDANCECLASS;
}

+(void) setAvailability:(Party * )party withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    PFQuery *query = [PFQuery queryWithClassName:ATTENDANCECLASS];
    [query whereKey:PARTYKEY equalTo:party];
    [query whereKey:USER equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable attendanceObject, NSError * _Nullable error) {
        Attendance *attendance;
        if (!error){
                attendance = (Attendance *) attendanceObject;
                if([attendance.attendanceType isEqualToString:GOING]){
                    attendance.attendanceType = MAYBE;
                    [attendance saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
                }
                else{
                    [attendance deleteInBackground];
                }
        }
        else{
            if(!attendanceObject){
                attendance = [Attendance new];
                attendance.party = party;
                attendance.user = [PFUser currentUser];
                attendance.attendanceType = GOING;
                [attendance saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
            }
            else{
                NSLog(@"%@", error.localizedDescription);
            }
        }
    }];
}
@end
