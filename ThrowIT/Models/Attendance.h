//
//  Attendance.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/12/22.
//

#import <Parse/Parse.h>
#import "Party.h"

NS_ASSUME_NONNULL_BEGIN

@interface Attendance : PFObject<PFSubclassing>
@property (nonatomic, strong) Party *party;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *attendanceType;
+(void) setAvailability:(Party * )party withCompletion: (PFBooleanResultBlock  _Nullable)completion;
@end

NS_ASSUME_NONNULL_END
