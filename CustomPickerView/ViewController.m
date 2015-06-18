//
//  ViewController.m
//  CustomPickerView
//
//  Created by onegray on 6/18/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ViewController.h"
#import "RulerCellView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.distanceSliderView.layer.borderWidth = 1;
	self.distanceSliderView.layer.borderColor = [[UIColor blackColor] CGColor];
	self.distanceSliderView.cellSize = CGSizeMake(70, 50);

	self.timeSliderView.layer.borderWidth = 1;
	self.timeSliderView.layer.borderColor = [[UIColor blackColor] CGColor];
	self.timeSliderView.cellSize = CGSizeMake(60, 50);

	__weak typeof(self) weakSelf = self;
	self.distanceSliderView.onUpdateDistanceHandler = ^(CGFloat distance, NSString* formattedDistance) {
		weakSelf.distanceLabel.text = formattedDistance;
	};
	self.timeSliderView.onUpdateTimeHandler = ^(NSTimeInterval timeInterval, NSString* formattedTimeInterval) {
		weakSelf.timeLabel.text = formattedTimeInterval;
	};
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	CGFloat margin = self.distanceSliderView.bounds.size.width/2 - self.distanceSliderView.cellSize.width/2;
	self.distanceSliderView.leftMargin = margin+2;
	self.distanceSliderView.rightMargin = margin-2;
	
	margin = self.timeSliderView.bounds.size.width/2 - self.timeSliderView.cellSize.width/2;
	self.timeSliderView.leftMargin = margin+2;
	self.timeSliderView.rightMargin = margin-2;

	self.distanceLabel.text = self.distanceSliderView.formattedDistance;
	self.timeLabel.text = self.timeSliderView.formattedTimeInterval;
}



@end
