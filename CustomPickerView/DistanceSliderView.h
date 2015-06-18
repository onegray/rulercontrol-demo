//
//  DistanceSliderView.h
//  CustomPickerView
//
//  Created by onegray on 6/18/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RulerSliderView.h"

@interface DistanceSliderView : RulerSliderView

@property (nonatomic, assign, readonly) CGFloat distance;
@property (nonatomic, strong, readonly) NSString* formattedDistance;

@property (nonatomic, copy) void (^onUpdateDistanceHandler)(CGFloat distance, NSString* formattedDistance);

@end
