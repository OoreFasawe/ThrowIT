//
//  Party.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/7/22.
//

#import "Party.h"
#import "Utility.h"

@implementation Party

@dynamic partyID;
@dynamic name;
@dynamic partyDescription;
@dynamic startTime;
@dynamic endTime;
@dynamic school;
@dynamic partyThrower;
@dynamic numberAttending;
@dynamic isGoing;
@dynamic maybe;
@dynamic isPublic;
@dynamic rating;
@dynamic partyCoordinateLongitude;
@dynamic partyCoordinateLatitude;
@dynamic partyLocationName;
@dynamic partyLocationAddress;
@dynamic partyLocationId;
@dynamic distancesFromUser;
@dynamic partyPhoto;

+ (nonnull NSString *)parseClassName {
    return PARTYCLASS;
}

+ (void) postNewParty:(Party *) party withPartyName:( NSString * _Nullable )partyName withDescription:(NSString * _Nullable)partyDescription withStartTime:(NSDate * _Nullable)startTime withEndTime:(NSDate* _Nullable)endTime withSchoolName:(NSString *_Nullable)school withPartyPhoto:(UIImage* _Nullable)partyPhoto withLocationName:(NSString *)partyLocationName withLocationAddress:(NSString *)partyLocationAddress withLocationCoordinate:(CLLocationCoordinate2D) partyCoordinate withLocationId:(NSString *) partyLocationId withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    Party *newParty = party;
    newParty.name = partyName;
    newParty.partyDescription = partyDescription;
    newParty.startTime=startTime;
    newParty.endTime=endTime;
    newParty.school = school;
    newParty.numberAttending= 0;
    newParty.isGoing=NO;
    newParty.maybe=NO;
    newParty.partyPhoto = [Utility getPFFileFromImage:partyPhoto];
    newParty.isPublic=NO;
    newParty.partyLocationName = partyLocationName;
    newParty.partyLocationAddress = partyLocationAddress;
    newParty.partyCoordinateLongitude = partyCoordinate.longitude;
    newParty.partyCoordinateLatitude = partyCoordinate.latitude;
    newParty.partyThrower = [PFUser currentUser];
    newParty.rating = 0;
    newParty.partyLocationId = partyLocationId;
    [newParty saveInBackgroundWithBlock: completion];
}

-(BOOL)isGoingOn{
    if([[NSDate now] earlierDate:self.startTime] == self.startTime && [[NSDate now] laterDate:self.endTime] == self.endTime)
        return true;
    else
        return false;
}


@end
