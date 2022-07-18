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


+ (nonnull NSString *)parseClassName {
    return PARTYCLASS;
}

+ (void) postNewParty:( NSString * _Nullable )partyName withDescription:(NSString * _Nullable)partyDescription withStartTime:(NSDate * _Nullable)startTime withEndTime:(NSDate* _Nullable)endTime withSchoolName:(NSString *_Nullable)school withBackGroundImage:(UIImage* _Nullable)backgroundImage withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    
    Party *newParty = [Party new];
    newParty.name = partyName;
    newParty.partyDescription = partyDescription;
    newParty.startTime=startTime;
    newParty.endTime=endTime;
    newParty.school = school;
    newParty.numberAttending= @(0);
    newParty.isGoing=NO;
    newParty.maybe=NO;
    newParty.backgroundImage = [self getPFFileFromImage:backgroundImage];
    newParty.isPublic=NO;
    newParty.partyThrower = [PFUser currentUser];
    newParty.rating = 0;
    
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
