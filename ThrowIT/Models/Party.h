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
@property (nonatomic, strong) PFFileObject *partyPhoto;
@property (nonatomic) BOOL isPublic;
@property (nonatomic) float rating;
@property (nonatomic) double partyCoordinateLongitude;
@property (nonatomic) double partyCoordinateLatitude;
@property (nonatomic, strong) NSString *partyLocationName;
@property (nonatomic, strong) NSString *partyLocationAddress;
@property (nonatomic, strong) NSString *partyLocationId;
@property (nonatomic, strong) NSString *distancesFromUser;

+ (void) postNewParty:(Party *) party withPartyName:( NSString * _Nullable )partyName withDescription:(NSString * _Nullable)partyDescription withStartTime:(NSDate * _Nullable)startTime withEndTime:(NSDate * _Nullable)endTime withSchoolName:(NSString * _Nullable)school withPartyPhoto:(UIImage* _Nullable)partyPhoto withLocationName:(NSString *)partyLocationName withLocationAddress:(NSString *)partyLocationAddress withLocationCoordinate:(CLLocationCoordinate2D) partyCoordinate withLocationId:(NSString *) partyLocationId withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;
-(BOOL)isGoingOn;

@end

NS_ASSUME_NONNULL_END
