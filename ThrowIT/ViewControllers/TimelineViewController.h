//
//  TimelineViewController.h
//  ThrowIT
//
//  Created by Oore Fasawe on 7/5/22.
//
#import "Utility.h"
#import "APIManager.h"
#import "Foundation/Foundation.h"
#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface TimelineViewController : UIViewController < UITableViewDelegate, UITableViewDataSource, CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource>
@end

NS_ASSUME_NONNULL_END
