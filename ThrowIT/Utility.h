//
//  Utility.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/15/22.
//

#import <Foundation/Foundation.h>
#pragma mark - Storyboard
#define MAIN @"Main"

#pragma mark - ViewControllers
#define LOGINVIEWCONTROLLER @"LoginViewController"
#define SIGNUPVIEWCONTROLLER @"SignUpViewController"
#define THROWERSIGNUPVIEWCONTROLLER @"ThrowerSignUpViewController"
#define THROWERTIMELINENAVIGATIONVIEWCONTROLLER @"ThrowerTimelineNavigationController"
#define THROWERWAITSCREENNAVIGATIONCONTROLLER @"ThrowerWaitScreenNavigationController"
#define TIMELINETABBARCONTROLLER @"TimelineTabBarController"

#pragma mark - Segues
#define DETAILSVIEWCONTROLLERFORCOLLECTIONCELL @"toDetailsViewControllerForCollectionCell"
#define DETAILSVIEWCONTROLLERFORTABLECELL @"toDetailsViewControllerForTableCell"
#define THROWERDETAILSVIEWCONTROLLER @"toThrowerDetailsViewController"
#define CREATEPARTYSEGUE @"createPartySegue"

#pragma mark - Models
#define PARTYCELL @"PartyCell"
#define THROWERPARTYCELL @"ThrowerPartyCell"
#define TOPPARTYCELL @"TopPartyCell"

#pragma mark - Parse Classes
#define PARTYCLASS @"Party"
#define THROWERCLASS @"Thrower"
#define ATTENDANCECLASS @"Attendance"

#pragma mark - Parse Keys
#define USER @"user"
#define USERISTHROWERKEY @"isThrower"

#define THROWERKEY @"thrower"
#define VERIFIEDKEY @"verified"
#define THROWERNAMEKEY @"throwerName"

#define PARTYKEY @"party"
#define PARTYTHROWERKEY @"partyThrower"

#define ATTENDANCETYPEKEY @"attendanceType"
#define NOTGOING @"Not going"
#define GOING @"Going"
#define MAYBE @"Maybe"

#define CREATEDAT @"createdAt"

#pragma mark - Array limits
#define QUERYLIMIT 20

NS_ASSUME_NONNULL_BEGIN

@interface Utility : NSObject

@end

NS_ASSUME_NONNULL_END
