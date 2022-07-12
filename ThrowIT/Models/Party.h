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
@property (nonatomic, strong) Thrower *partyThrower;
@property (nonatomic, strong) NSNumber *numberAttending;
@property (nonatomic) BOOL isGoing;
@property (nonatomic) BOOL maybe;
@property (nonatomic, strong) PFFileObject *backgroundImage;
@property (nonatomic) BOOL isPublic;


+ (void) postNewParty: ( NSString * _Nullable )partyName withDescription:(NSString * _Nullable)partyDescription withStartTime:(NSDate * _Nullable)startTime withEndTime:(NSDate * _Nullable)endTime withSchoolName:(NSString *)school withBackGroundImage:(UIImage* _Nullable)backgroundImage withCompletion: (PFBooleanResultBlock  _Nullable)completion;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;


@end

NS_ASSUME_NONNULL_END
