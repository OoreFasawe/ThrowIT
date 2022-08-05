//
//  Check In.h
//  ThrowIT
//
//  Created by Oore Fasawe on 8/4/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Party.h"
#import "Utility.h"

NS_ASSUME_NONNULL_BEGIN

@interface Check_In : PFObject <PFSubclassing>
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) Party *party;

+(void)postNewCheckInForParty:(Party *) party withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+(void)userIsCheckedIn:(Party *) party withCompletion:(void (^)(BOOL checkInExists))completion;
@end

NS_ASSUME_NONNULL_END
