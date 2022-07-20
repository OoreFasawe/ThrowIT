//
//  APIManager.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/18/22.
//

#import "APIManager.h"
#import "TimelineViewController.h"
@import GooglePlaces;
@import GoogleMaps;
static int runCount = 0;


@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
    
}

-(void)locationManagerInit{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self->locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

-(void)loadDistanceDataIntoArray:(NSMutableArray *)array withDestinationLocation:(NSString *)destinationPlaceId withArrayIndex:(int)arrayIndex withCount:(NSUInteger)count withCompletionHandler:(void (^)(BOOL success))completion{
    NSString *path = [[NSBundle mainBundle] pathForResource: KEYSFILENAME ofType: KEYSFILETYPE];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile: path];
    NSString *key = [dict objectForKey: GOOGLEMAPSAPIKEY];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:CONSUMERKEY]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:CONSUMERKEY];
    }
    NSString *totalString = [NSString stringWithFormat:URLSTRINGFORMAT, BASEURL, destinationPlaceId, currentLocation.coordinate.latitude, currentLocation.coordinate.longitude, key];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:totalString]];
    [request setHTTPMethod:GETMETHOD];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData * _Nullable data,
        NSURLResponse * _Nullable response,
        NSError * _Nullable error) {
        if(!error){
            runCount++;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            array[arrayIndex] = MILEDATAPATH;
            if (runCount == count)
                return completion(YES);
        }
        else{
            NSLog(@"%@", error.localizedDescription);
        }
    }] resume];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [locationManager stopUpdatingLocation];
    currentLocation = [locations lastObject];
}
@end
