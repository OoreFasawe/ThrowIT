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
@dynamic backgroundImage;
@dynamic isPublic;
@dynamic rating;
@dynamic partyCoordinateLongitude;
@dynamic partyCoordinateLatitude;
@dynamic partyLocationName;
@dynamic partyLocationAddress;


+ (nonnull NSString *)parseClassName {
    return PARTYCLASS;
}

+ (void) postNewParty:(Party *) party withPartyName:( NSString * _Nullable )partyName withDescription:(NSString * _Nullable)partyDescription withStartTime:(NSDate * _Nullable)startTime withEndTime:(NSDate* _Nullable)endTime withSchoolName:(NSString *_Nullable)school withBackGroundImage:(UIImage* _Nullable)backgroundImage withLocationName:(NSString *)partyLocationName withLocationAddress:(NSString *)partyLocationAddress withLocationCoordinate:(CLLocationCoordinate2D) partyCoordinate withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    
    Party *newParty = party;
    newParty.name = partyName;
    newParty.partyDescription = partyDescription;
    newParty.startTime=startTime;
    newParty.endTime=endTime;
    newParty.school = school;
    newParty.numberAttending= 0;
    newParty.isGoing=NO;
    newParty.maybe=NO;
    newParty.backgroundImage = [self getPFFileFromImage:backgroundImage];
    newParty.isPublic=NO;
    newParty.partyLocationName = partyLocationName;
    newParty.partyLocationAddress = partyLocationAddress;
    newParty.partyCoordinateLongitude = partyCoordinate.longitude;
    newParty.partyCoordinateLatitude = partyCoordinate.latitude;
    newParty.partyThrower = [PFUser currentUser];
    
    [newParty saveInBackgroundWithBlock: completion];

}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {

    // check if image is not nil
    if (!image) {
        return nil;
    }

    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}


@end
