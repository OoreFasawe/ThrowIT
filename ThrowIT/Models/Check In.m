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
    return @"Check In";
}

-(void)postNewCheckInForParty:(Party *) party withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    Check_In *checkIn = [Check_In new];
    checkIn.user = [PFUser currentUser];
    checkIn.party = party;
    [checkIn saveInBackgroundWithBlock: completion];
}
@end
