//
//  TimeSliderView.h
//  CustomPickerView
//
//  Created by onegray on 6/18/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RulerSliderView.h"

@interface TimeSliderView : RulerSliderView

@property (nonatomic, assign, readonly) NSTimeInterval timeInterval;
@property (nonatomic, strong, readonly) NSString* formattedTimeInterval;

@property (nonatomic, copy) void (^onUpdateTimeHandler)(NSTimeInterval timeInterval, NSString* formattedTimeInterval);

@end
