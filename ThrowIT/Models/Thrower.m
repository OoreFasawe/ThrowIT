//
//  Thrower.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/7/22.
//

#import "Thrower.h"

@implementation Thrower

@dynamic throwerName;
@dynamic school;
@dynamic throwerRating;

+ (nonnull NSString *)parseClassName {
    return @"Thrower";
}

+ (void) postNewThrower: (NSString * _Nullable)throwerName withSchool:(NSString * _Nullable)partySchool withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Thrower *partyThrower = [Thrower new];
    partyThrower.throwerName = throwerName;
    partyThrower.school = partySchool;
    partyThrower.throwerRating = 0;
    
    [partyThrower saveInBackgroundWithBlock: completion];
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
