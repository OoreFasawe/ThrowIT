//
//  Thrower.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/7/22.
//

#import "Thrower.h"
#import "Utility.h"

@implementation Thrower

@dynamic throwerName;
@dynamic school;
@dynamic throwerRating;
@dynamic verified;
@dynamic thrower;

+ (nonnull NSString *)parseClassName {
    return THROWERCLASS;
}

+ (void) postNewThrower: (Thrower *)partyThrower withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    partyThrower.throwerRating = 0;
    partyThrower.verified = NO;
    [partyThrower saveInBackgroundWithBlock: completion];
}

+ (BOOL)isThowerVerified: (NSString* )throwerUsername{
    __block BOOL isVerified = FALSE;
    PFQuery *query = [PFQuery queryWithClassName:THROWERCLASS];
    [query whereKey:THROWERNAMEKEY equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *throwerList, NSError *error) {
        if(throwerList !=nil){
            isVerified = throwerList[0][VERIFIEDKEY];
        }
        else{
            isVerified = FALSE;
        }
    }];
    return FALSE;
}

@end
