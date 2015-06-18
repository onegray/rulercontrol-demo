//
//  ViewController.h
//  CustomPickerView
//
//  Created by onegray on 6/18/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DistanceSliderView.h"
#import "TimeSliderView.h"

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet DistanceSliderView* distanceSliderView;
@property (nonatomic, strong) IBOutlet UILabel* distanceLabel;

@property (nonatomic, strong) IBOutlet TimeSliderView* timeSliderView;
@property (nonatomic, strong) IBOutlet UILabel* timeLabel;

@end

