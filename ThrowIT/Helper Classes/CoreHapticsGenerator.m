//
//  CoreHapticsGenerator.m
//  ThrowIT
//
//  Created by Oore Fasawe on 7/21/22.
//

#import "CoreHapticsGenerator.h"

@implementation CoreHapticsGenerator

+(instancetype)initWithEngineOnViewController:(UIViewController *)viewController{
    if(CHHapticEngine.capabilitiesForHardware.supportsHaptics){
        NSError* error;
        CoreHapticsGenerator *myGenerator = [[CoreHapticsGenerator alloc] init];
        myGenerator.engine = [[CHHapticEngine alloc] initAndReturnError:&error];
        __weak CoreHapticsGenerator *weakMyGenerator = myGenerator;
        [myGenerator.engine setResetHandler:^{
            NSError* startupError;
            [weakMyGenerator.engine startAndReturnError:&startupError];
            if (startupError) {
            }
        }];
        return myGenerator;
    }
    return nil;
}

-(void)playAttendanceSound{
    NSDictionary* hapticDict = @{
        CHHapticPatternKeyPattern: @[
            @{ CHHapticPatternKeyEvent: @{
                CHHapticPatternKeyEventType: CHHapticEventTypeHapticTransient,
                CHHapticPatternKeyTime: @(CHHapticTimeImmediate),
                CHHapticPatternKeyEventDuration: @1.0 },
            },
        ],
    };
    NSError* error;
    CHHapticPattern* pattern = [[CHHapticPattern alloc] initWithDictionary:hapticDict error:&error];
    error = nil;
    self.player = [self.engine createPlayerWithPattern:pattern error:&error];
    [self.engine notifyWhenPlayersFinished:^CHHapticEngineFinishedAction(NSError * _Nullable error) {
        return CHHapticEngineFinishedActionStopEngine;
    }];
    [self.engine startWithCompletionHandler:^(NSError* returnedError) {
        NSError* error;
        [self.player startAtTime:0 error:&error];
    }];
}
@end
