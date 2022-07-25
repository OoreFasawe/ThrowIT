//
//  Utility.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/15/22.
//

#import "Utility.h"
#import "APIManager.h"
#import "Party.h"
#import "TimelineViewController.h"
static int apiRunCount;
static int filterRunCount;

@implementation Utility
+(void)TakeOrChooseImage:(UIViewController *)viewController withSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = viewController;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = sourceType;
    [viewController presentViewController:imagePickerVC animated:YES completion:nil];
}

+(NSMutableArray *)getDistancesFromArray:(NSArray *)array withCompletionHandler:(void (^)(BOOL success ))completion{
    NSMutableArray *distances = [NSMutableArray new];
    NSMutableArray *place_Ids = [self initLocationsWithArray:array];
    for(int i = 0; i < place_Ids.count; i++)
    {
        [distances addObject:PARTYDISTANCELABELPLACEHOLDER];
        [[APIManager shared] loadDistanceDataFromLocation:place_Ids[i] withCompletionHandler:^(NSString * distance) {
            if (distance)
            {
                apiRunCount++;
                distances[i] = distance;
                if(apiRunCount == place_Ids.count){
                    apiRunCount = 0;
                    completion(YES);
                }
            }
        }];
    }
    return distances;
}

+(NSMutableArray*)initLocationsWithArray:(NSArray *)array{
    NSMutableArray *place_Ids = [NSMutableArray new];
    for(Party *party in array){
        NSString *place_id = party.partyLocationId;
        [place_Ids addObject:place_id];
    }
    return place_Ids;
}
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
    if (!image)
        return nil;
    NSData *imageData = UIImagePNGRepresentation(image);
    if (!imageData)
        return nil;
    return [PFFileObject fileObjectWithName:PARSEIMAGEDEFAULTFILENAME data:imageData];
}
-(void)setAttendanceState:(UIButton *)attendanceButton{
    if([attendanceButton.titleLabel.text isEqualToString:GOING]){
        [attendanceButton setTitle:MAYBE forState:UIControlStateNormal];
    }
    else if([attendanceButton.titleLabel.text isEqualToString:MAYBE]){
        [attendanceButton setTitle:NOTGOING forState:UIControlStateNormal];
    }
    else{
        [attendanceButton setTitle:GOING forState:UIControlStateNormal];
    }
}

+(void)addDistanceDataToList:(NSMutableArray *)partyList fromList:(NSMutableArray *)distanceList{
    for(int i = 0; i < partyList.count; i++){
        Party *someParty = partyList[i];
        someParty.distancesFromUser = distanceList[i];
    }
}

+(NSMutableArray *)getFilteredListFromList:(NSMutableArray *)partyList withDistanceLimit:(double)distanceLimit withPartyCountlimit:(int)partyCountLimit withRatingLimit:(double) ratingLimit withCompletionHandler:(void (^)(BOOL success))completion{
    NSMutableArray *filteredList = [NSMutableArray new];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    for(int i = 0; i < partyList.count; i++){
        Party *party = partyList[i];
        //filter rating
        PFQuery *throwerQuery = [PFQuery queryWithClassName:THROWERCLASS];
        [throwerQuery whereKey:THROWERKEY equalTo:party.partyThrower];
        [throwerQuery getFirstObjectInBackgroundWithBlock:^(PFObject * thrower, NSError * error) {
            filterRunCount++;
            if(!error){
                Thrower *partyThrower = (Thrower *)thrower;
                if(partyThrower.throwerRating >= ratingLimit)
                    {
                        //filter distance
                        if(distanceLimit >= [[f numberFromString:[party.distancesFromUser componentsSeparatedByString:SPACE][0]] doubleValue] || [[party.distancesFromUser componentsSeparatedByString:SPACE][1] isEqualToString:FEET]){
                            // filter party count
                            if(party.numberAttending >= partyCountLimit){
                                [filteredList addObject:party];
                            }
                        }
                    }
                }
                else
                {
                    NSLog(@"%@", error.localizedDescription);
                }
            
            if(filterRunCount == partyList.count){
                filterRunCount = 0;
                completion(YES);
            }
        }];
    }
    return filteredList;
}

@end
