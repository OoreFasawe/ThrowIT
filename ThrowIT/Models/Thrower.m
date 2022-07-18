//
//  Thrower.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/7/22.
//

#import "Thrower.h"
#import "Utility.h"

@implementation Thrower

@dynamic throwerName;
@dynamic school;
@dynamic throwerRating;
@dynamic verified;
@dynamic thrower;

+ (nonnull NSString *)parseClassName {
    return THROWERCLASS;
}

+ (void) postNewThrower: (Thrower *)partyThrower withCompletion: (PFBooleanResultBlock  _Nullable)completion {

    partyThrower.throwerRating = 0;
    partyThrower.verified = NO;
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

+ (BOOL)isThowerVerified: (NSString* )throwerUsername{
    __block BOOL isVerified = FALSE;
    PFQuery *query = [PFQuery queryWithClassName:THROWERCLASS];
    [query whereKey:THROWERNAMEKEY equalTo:[PFUser currentUser]];


    [query findObjectsInBackgroundWithBlock:^(NSArray *throwerList, NSError *error) {
        if(throwerList !=nil){
            isVerified = throwerList[0][VERIFIEDKEY];
        }
        else{
            NSLog(@"Thrower list is nil");
            isVerified = FALSE;
        }
    }];
    return FALSE;
}

@end
