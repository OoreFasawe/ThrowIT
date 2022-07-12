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
@dynamic verified;
@dynamic thrower;

+ (nonnull NSString *)parseClassName {
    return @"Thrower";
}

//+ (void) postNewThrower: (NSString * _Nullable)throwerName withSchool:(NSString * _Nullable)partySchool withUser: (PFUser *)throwerUser withCompletion: (PFBooleanResultBlock  _Nullable)completion {
//
//    Thrower *partyThrower = [Thrower new];
//    partyThrower.throwerName = throwerName;
//    partyThrower.school = partySchool;
//    partyThrower.thrower = throwerUser;
//    partyThrower.throwerRating = 0;
//    partyThrower.verified = NO;
//
//
//    [partyThrower saveInBackgroundWithBlock: completion];
//}
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
    PFQuery *query = [PFQuery queryWithClassName:@"Thrower"];
    [query whereKey:@"throwerName" equalTo:throwerUsername];

    [query findObjectsInBackgroundWithBlock:^(NSArray *throwerList, NSError *error) {
        if(throwerList !=nil){
            isVerified = throwerList[0][@"verified"];
        }
        else{
            NSLog(@"Thrower list is nil");
            isVerified = FALSE;
        }
        
    }];
        
    return FALSE;
}

//-(NSArray *)ExistingThrowerArray{
//    PFQuery *query = [PFQuery queryWithClassName:@"Thrower"];
//    [query whereKey:@"throwerName" equalTo:self.throwerNameField.text];
//    [query whereKey:@"throwerEmail" equalTo:self.throwerEmailField.text];
//    [query whereKey:@"school" equalTo:self.throwerSchoolField.text];
//
//    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
//        if(posts !=nil){
//            self.duplicateThrowerList = posts;
//        }
//    }];
//    return self.duplicateThrowerList;
//}

@end
