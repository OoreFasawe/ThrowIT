//
//  Thrower.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/7/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Thrower : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *throwerName;
@property (nonatomic, strong) NSString *school;
@property (nonatomic) double throwerRating;
@property (nonatomic) BOOL verified;
@property (nonatomic, strong) PFUser *thrower;

//
//+ (void) postNewThrower: (NSString * _Nullable)throwerName withSchool:(NSString * _Nullable)partySchool withUser: (PFUser *)throwerUser withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (void) postNewThrower: (Thrower *)partyThrower withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;
+ (BOOL)isThowerVerified: (NSString *)throwerUsername;

@end

NS_ASSUME_NONNULL_END
