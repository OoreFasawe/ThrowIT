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
#define ATTENDEDPARTYCELL @"AttendedPartyCell"
#define THROWBOARDCELL @"ThrowBoardCell"
#define THROWNPARTYCELL @"ThrownPartyCell"
#define RANKCELL @"RankCell"
#define SEARCHCELL @"SearchCell"
#define SHIFTNUMBER 3
#define NUMBEROFROWSINSECTION 1

#pragma mark - Parse Classes
#define PARTYCLASS @"Party"
#define THROWERCLASS @"Thrower"
#define ATTENDANCECLASS @"Attendance"
#define USERCLASS @"_User"
#define CHECKINCLASS @"Check_In"

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
#define NOTGOING @"Not going"
#define GOING @"Going"
#define MAYBE @"Maybe"

#define CREATEDAT @"createdAt"
#define ENDTIME @"endTime"

#pragma mark - Helper Constants
#define PARSEIMAGEDEFAULTFILENAME @"image.png"
#define PARTYIMAGEDEFAULT @"step2"
#define EMPTY @""
#define SPACE @" "
#define TIMEINTERVAL 4*3600
#define TIMEFORMAT @"hh:mm a"
#define CHECKED @"Checked"
#define MAPOFFSET 60
#define MAPDISTANCEFROMDIRBUTTON 16
#define MAPHEIGHT 388
#define NOW @". Now"
#define ATTENDEDPARTYRATINGFORMAT @"Rating: %.1f / 5"
#define OBJECTTEXTAFTERPERIOD @". %@"
#define HEADCOUNTTEXT @"Headcount: %d"
#define YOU @"You"
#define PARTYTHROWNCOUNT @"Parties Thrown: %d"
#define PARTYCELLPARTTIMETEXTFORMAT @". In %@"
#define THROWERPARTYCELLHEADCOUNTTEXTFORMAT @"%ld coming"
#define BORDERWIDTH 0.05
#define CELLCORNERRADIUS 10
#define IMAGECORNERRADIUS 5
#define FOOTERHEIGHTCONSTANT 5
#define FONTSIZEFORUSERNAME 17
#define MAPZOOMCONSTANT 16
#define MINDISTANCE 1.0
#define COLLECTIONVIEWBORDER 2.5
#define ERRORTEXTFORMAT @"Error: %@"

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
#define IMAGERESIZECONSTANT 500

#pragma mark - Login/SignUp Animation Constants
#define TOSIGNUPSANIMATIONDEFAULTDURATION 0.5
#define SIGNUPBARSCALEFACTOR 25.f
#define LOGINANIMATIONVIEWSCALEFACTOR 2.f

#pragma mark - Error Handling Constants
#define CHECKINFAILED @"Check-in failed."
#define TOOFARFROMPARTY @"Too far from party to check in."
#define CHECKINEXISTS @"Already checked in."
#define PARTYENDED @"Party ended."
#define OK @"Ok"
#define CANNNOTGETPARTIES @"Cannot Get Parties"
#define NOINTERNET @"The internet connection appears to be offline."
#define TRYAGAIN @"Try Again"
#define MISSINGFIELDS @"Missing Fields"
#define COMPLETEFIELDS @"Please fill in all fields"
#define UNHANDLEDEDITINGSTYLE @"Unhandled editing style! %ld"
#define DATEERRORMESSAGE @"Invalid Date"
#define STARTDATEERRORMESSAGE @"Set start date later than current date"
#define ENDDATEERRORMESSAGE @"Set end date later than start date"

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
