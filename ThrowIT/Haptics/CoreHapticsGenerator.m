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
            //TODO: Try restarting the engine again.
            NSError* startupError;
            [weakMyGenerator.engine startAndReturnError:&startupError];
            if (startupError) {
            }
            //TODO: Register any custom resources you had registered, using registerAudioResource.
            //TODO: Recreate all haptic pattern players you had created, using createPlayer.
        }];
        [myGenerator.engine setStoppedHandler:^(CHHapticEngineStoppedReason reason){
            switch (reason)
            {
                case CHHapticEngineStoppedReasonAudioSessionInterrupt: {
                    // TODO: A phone call or notification could have come in, so take note to restart the haptic engine after the call ends. Wait for user-initiated playback.
                    break;
                }
                case CHHapticEngineStoppedReasonApplicationSuspended: {
                    // TODO: The user could have backgrounded your app, so take note to restart the haptic engine when the app reenters the foreground. Wait for user-initiated playback.
                    break;
                }
                case CHHapticEngineStoppedReasonIdleTimeout: {
                    // TODO: The system stopped an idle haptic engine to conserve power, so restart it before your app must play the next haptic pattern.
                    break;
                }
                case CHHapticEngineStoppedReasonSystemError: {
                    // TODO: The system faulted, so either continue without haptics or terminate the app.
                    break;
                }
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
    
    // Stop the engine after it completes the playback.
    [self.engine notifyWhenPlayersFinished:^CHHapticEngineFinishedAction(NSError * _Nullable error) {
        return CHHapticEngineFinishedActionStopEngine;
    }];
    
    [self.engine startWithCompletionHandler:^(NSError* returnedError) {
        NSError* error;
        [self.player startAtTime:0 error:&error];
    }];
    
    
}
@end
