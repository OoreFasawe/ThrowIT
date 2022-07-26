//
//  CoreHapticsGenerator.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/21/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CoreHaptics/CoreHaptics.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreHapticsGenerator : NSObject
@property (nonatomic, strong) CHHapticEngine *engine;
@property (nonatomic, strong) id<CHHapticPatternPlayer>player;
+(instancetype)initWithEngineOnViewController:(UIViewController *)viewController;
-(void)playAttendanceSound;
@end

NS_ASSUME_NONNULL_END
