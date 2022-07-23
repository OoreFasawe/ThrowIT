//
//  Party.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/7/22.
//

#import <Foundation/Foundation.h>
#import "Thrower.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface Party : PFObject <PFSubclassing>
@property (nonatomic, strong) NSString *partyID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *partyDescription;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, strong) NSString *school;
@property (nonatomic, strong) PFUser *partyThrower;
@property (nonatomic) NSInteger numberAttending;
@property (nonatomic) BOOL isGoing;
@property (nonatomic) BOOL maybe;
@property (nonatomic, strong) PFFileObject *backgroundImage;
@property (nonatomic) BOOL isPublic;
@property (nonatomic) int rating;
@property (nonatomic) double partyCoordinateLongitude;
@property (nonatomic) double partyCoordinateLatitude;
@property (nonatomic, strong) NSString *partyLocationName;
@property (nonatomic, strong) NSString *partyLocationAddress;
@property (nonatomic, strong) NSString *partyLocationId;

+ (void) postNewParty:(Party *) party withPartyName:( NSString * _Nullable )partyName withDescription:(NSString * _Nullable)partyDescription withStartTime:(NSDate * _Nullable)startTime withEndTime:(NSDate * _Nullable)endTime withSchoolName:(NSString * _Nullable)school withBackGroundImage:(UIImage* _Nullable)backgroundImage withLocationName:(NSString *)partyLocationName withLocationAddress:(NSString *)partyLocationAddress withLocationCoordinate:(CLLocationCoordinate2D) partyCoordinate withLocationId:(NSString *) partyLocationId withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;


@end

NS_ASSUME_NONNULL_END
