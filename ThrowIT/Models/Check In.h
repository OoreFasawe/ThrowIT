//
//  Check In.h
//  ThrowIT
//
//  Created by Oore Fasawe on 8/4/22.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"
#import "Party.h"

NS_ASSUME_NONNULL_BEGIN

@interface Check_In : PFObject <PFSubclassing>
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) Party *party;

-(void)postNewCheckInForParty:(Party *) party withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
