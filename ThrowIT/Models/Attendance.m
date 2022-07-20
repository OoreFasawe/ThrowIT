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
    [query findObjectsInBackgroundWithBlock:^(NSArray  *attendanceList, NSError *error) {
        if (!error){
            //if there's not attendance object, create one
            Attendance *attendance;
            if(!attendanceList.count){
                attendance = [Attendance new];
                attendance.party = party;
                attendance.user = [PFUser currentUser];
                attendance.attendanceType = GOING;
                
                [attendance saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
            }
            //if there's an attendance object, check it's attendance type
            else{
                attendance = attendanceList[0];
                //if attendancetype is going, change to maybe, if maybe delete;
                if([attendance.attendanceType isEqualToString:GOING]){
                    attendance.attendanceType = MAYBE;
                    [attendance saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {}];
                }
                else{
                    [attendance deleteInBackground];
                }
            }
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}
@end
