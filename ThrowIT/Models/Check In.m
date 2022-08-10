//
//  Check In.m
//  ThrowIT
//
//  Created by Oore Fasawe on 8/4/22.
//

#import "Check In.h"

@implementation Check_In
@dynamic user;
@dynamic party;

+ (nonnull NSString *)parseClassName {
    return CHECKINCLASS;
}

+(void)postNewCheckInForParty:(Party *) party withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    Check_In *checkIn = [Check_In new];
    checkIn.user = [PFUser currentUser];
    checkIn.party = party;
    [checkIn saveInBackgroundWithBlock: completion];
}

+(void)userIsCheckedIn:(Party *) party withCompletion:(void (^)(BOOL checkInExists))completion{
    PFQuery *checkInQuery = [PFQuery queryWithClassName:CHECKINCLASS];
    [checkInQuery whereKey:USER equalTo:[PFUser currentUser]];
    [checkInQuery whereKey:PARTYKEY equalTo:party];
    [checkInQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if(!error)
        {
            if(number)
                completion(YES);
            else
                completion(NO);
        }
        else
            NSLog(@"error: %@", error.localizedDescription);
    }];
}
@end
