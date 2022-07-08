//
//  Thrower.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/7/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Thrower : PFObject <PFSubclassing>
@property (nonatomic, strong) NSString *throwerName;
@property (nonatomic, strong) NSString *school;
@property (nonatomic) double throwerRating;



+ (void) postNewThrower: (NSString * _Nullable)throwerName withSchool:(NSString * _Nullable)partySchool withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

@end

NS_ASSUME_NONNULL_END
