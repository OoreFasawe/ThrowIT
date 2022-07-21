//
//  CoreHapticsGenerator.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/21/22.
//

#import "CoreHapticsGenerator.h"

@implementation CoreHapticsGenerator

-(instancetype)initWithEngine{
    NSError* error;
    CoreHapticsGenerator *mygenerator = [[CoreHapticsGenerator alloc] init];
    mygenerator.engine = [[CHHapticEngine alloc] initAndReturnError:&error];
    
    return mygenerator;
}
@end
