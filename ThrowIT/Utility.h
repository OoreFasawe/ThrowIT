//
//  Utility.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/15/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#pragma mark - Storyboard
#define MAIN @"Main"

#pragma mark - ViewControllers
#define LOGINVIEWCONTROLLER @"LoginViewController"
#define SIGNUPVIEWCONTROLLER @"SignUpViewController"
#define THROWERSIGNUPVIEWCONTROLLER @"ThrowerSignUpViewController"
#define THROWERTIMELINENAVIGATIONVIEWCONTROLLER @"ThrowerTimelineNavigationController"
#define THROWERTIMELINETABBARCONTROLLER @"ThrowerTimelineTabBarController"
#define THROWERWAITSCREENNAVIGATIONCONTROLLER @"ThrowerWaitScreenNavigationController"
#define TIMELINETABBARCONTROLLER @"TimelineTabBarController"
#define TIMELINEVIEWCONTROLLER @"TimelineViewController"

#pragma mark - Segues
#define DETAILSVIEWCONTROLLERFORCOLLECTIONCELL @"toDetailsViewControllerForCollectionCell"
#define DETAILSVIEWCONTROLLERFORTABLECELL @"toDetailsViewControllerForTableCell"
#define THROWERDETAILSVIEWCONTROLLER @"toThrowerDetailsViewController"
#define CREATEPARTYSEGUE @"createPartySegue"
#define FILTERSEGUE @"filterSegue"

#pragma mark - Models
#define PARTYCELL @"PartyCell"
#define PARTYCELLPARTYRATINGTEXTFORMAT @". Usually %@ / 5"
#define TOPPARTYCELLPARTYRATINGTEXTFORMAT @"%@ / 5"
#define PARTYDISTANCELABELPLACEHOLDER @" ..."
#define THROWERPARTYCELL @"ThrowerPartyCell"
#define TOPPARTYCELL @"TopPartyCell"
#define SHIFTNUMBER 3
#define NUMBEROFROWSINSECTION 1

#pragma mark - Parse Classes
#define PARTYCLASS @"Party"
#define THROWERCLASS @"Thrower"
#define ATTENDANCECLASS @"Attendance"
#define USERCLASS @"_User"

#pragma mark - Parse Keys
#define USER @"user"
#define USERISTHROWERKEY @"isThrower"
#define USERPROFILEPHOTOKEY @"profilePhoto"
#define USERUSERNAMEKEY @"username"
#define PARTIESATTENDEDKEY @"partiesAttended"

#define THROWERKEY @"thrower"
#define VERIFIEDKEY @"verified"
#define THROWERNAMEKEY @"throwerName"
#define THROWERRATING @"throwerRating"

#define PARTYKEY @"party"
#define PARTYTHROWERKEY @"partyThrower"

#define ATTENDANCETYPEKEY @"attendanceType"
#define NOTGOING @"Pass"
#define GOING @"Crash"
#define MAYBE @"Maybe"

#define CREATEDAT @"createdAt"

#define PARSEIMAGEDEFAULTFILENAME @"image.png"
#define PARTYIMAGEDEFAULT @"step2"
#define EMPTY @""
#define SPACE @" "
#define TIMEINTERVAL 4*3600

#pragma mark - Query Limits
#define QUERYLIMIT 20
#define YESKEYWORD @YES
#define NOKEYWORD @NO
#define ZERO @0

#pragma mark - Party Filter constants
#define SPACE @" "
#define FEET @"ft"
#define DISTANCELABELTEXTFORMAT @"%.1f miles"
#define ATTENDANCELABELTEXTFORMAT @"%ld and above"
#define RATINGLABELTEXTFORMAT @"%.1f / 5"
#define DISTANCELIMITDEFAULT 50.0
#define PARTYCOUNTLIMITDEFAULT 0
#define RATINGLIMITDEFAULT 0.0

#pragma mark - API Info
#define BASEURL @"https://maps.googleapis.com/maps/api/distancematrix/json"
#define APIURLSTRINGFORMAT @"%@?destinations=place_id:%@&origins=%f,%f&units=imperial&key=%@"
#define GOOGLEMAPSAPIKEY @"google_Maps_API_Key"
#define KEYSFILENAME @"Keys"
#define KEYSFILETYPE @"plist"
#define GETMETHOD @"GET"
#define CONSUMERKEY @"consumer-key"
#define MILEDATAPATH json[@"rows"][0][@"elements"][0][@"distance"][@"text"]
#define PARSECLIENTKEY @"parse_Client_Key"
#define PARSEAPPID @"parse_ApplicationId"
#define PARSESERVER @"https://parseapi.back4app.com"
#define OPENDIRECTIONSTITLE @"Open Directions"
#define OPENDIRECTIONSMESSAGE @"Choose an app to open directions"
#define ALERTACTIONGOOGLEMAPSTITLE @"Google Maps"
#define LAUNCHURLFORGOOGLEMAPS @"comgooglemaps://?daddr=(%lf,%lf)&directionsmode=driving&zoom=14&views=traffic"
#define ALERTACTIONAPPLEMAPSTITLE @"Apple Maps"
#define DESTINATION @"Destination"

#pragma mark - Profile Picture Constants
#define ADDPROFILEPHOTO @"Add Profile photo"
#define ADDPARTYPHOTO @"Add Party Poster / Photo"
#define TAKEPHOTO @"Take Photo"
#define CHOOSEFROMLIBRARY @"Choose from library"
#define CANCEL @"Cancel"
#define ORIGINALXPOSITION 1.f
#define ORIGINALYPOSITION 1.f
#define DEFAULTDURATION 0.3
#define SIZEMULTIPLIER 2.5

NS_ASSUME_NONNULL_BEGIN
@interface Utility : NSObject
+(void)TakeOrChooseImage:(UIViewController *)viewController withSourceType:(UIImagePickerControllerSourceType)sourceType;
+(void)showImageTakeOptionSheetOnViewController:(UIViewController *) viewController withTitleString:(NSString *)titleString;
+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size;
+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;
-(void)setAttendanceState:(UIButton *)attendanceButton;
+(NSMutableArray*)initLocationsWithArray:(NSArray *)array;
+(NSMutableArray *)getDistancesFromArray:(NSArray *)array withCompletionHandler:(void (^)(BOOL success ))completion;
+(void)addDistanceDataToList:(NSMutableArray *)partyList fromList:(NSMutableArray *)distanceList;
+(NSMutableArray *)getFilteredListFromList:(NSMutableArray *)partyList withDistanceLimit:(double)distanceLimit withPartyCountlimit:(int)partyCount withRatingLimit:(double) ratingLimit withCompletionHandler:(void (^)(BOOL success))completion;
@end

NS_ASSUME_NONNULL_END
