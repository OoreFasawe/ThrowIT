# ThrowIT Design Product Spec

Throw It is an app that let’s users not only find, but also throw parties/events happening around their school.

## 1. User Stories (Required and Optional)

**Required Must-have Stories**

 * User can login(easy)
 * User can Sign up(easy)-either as Thrower or individual
 * User can view parties on the timeline(easy)
 * User can log out(easy)
 * User can express interest in parties(medium)
 * User can view profile and see parties they’ve attended and ratings for those parties(medium)
 * Throwers can do some identity verification(possibly using a library to check ID cards for school name/logo)


**Optional Nice-to-have Stories**

 * User can view live videos for a party happening(hard)
 * User can change to dark mode(medium)- have a color class full of system colors
 * User can order packages for parties/events(medium)
 * User can find location towards party destination(hard)
 * User can link account to Instagram/Facebook

## 2. Screen Archetypes

 * Login Screen
   * User can login
   * ...
 * Sign up
   * User can sign up
   * User can either sign up as individual or Thrower
   * ...
 * Timeline
   * User can view parties on the timeline
   * User can express interest in parties
   * User can log out
   * User can order packages for parties/events
   * ...
 * Profile
   * User can view profile and see parties they’ve attended and ratings for those parties
   * ...
 * Map 
   * User can find location towards party destination
   * ...
 * Settings
   * User can change to dark mode
   * ...


## 3. Navigation
**Tab Navifation(Tab to Screen)
 * For party goer
   * TimelineView Controller
   * Profile View Controller
   
**Flow Navigation** (Screen to Screen)
 * For thrower
   * Thrower Timeline View Controller
     * CreatePartyController
     * DetailsViewController from cell
 * For party goer
   * TimelineView Controller
     * DetailsViewController from cells
   * Profile View Controller
     * Settings View Controller

## 4. Data Models
 * Party
    * NSString *partyID;
    * NSString *name;
    * NSString *partyDescription;
    * NSDate *startTime;
    * NSDate *endTime;
    * NSString *school;
    * PFUser *partyThrower;
    * int numberAttending;
    * BOOL isGoing;
    * BOOL maybe;
    * PFFileObject *backgroundImage;
    * BOOL isPublic;
    * int rating;

 * Thrower
    * NSString *throwerName;
    * NSString *school;
    * double throwerRating;
    * BOOL verified;
    * PFUser *thrower;
	
 * Attendance
    * Party *party;
    * PFUser *user;
    * NSString *attendanceType;

