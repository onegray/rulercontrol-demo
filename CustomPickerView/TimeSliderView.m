//
//  TimeSliderView.m
//  CustomPickerView
//
//  Created by onegray on 6/18/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

#import "TimeSliderView.h"
#import "RulerCellView.h"

@interface TimeSliderView()
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, strong) NSString* formattedTimeInterval;
@end

@implementation TimeSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initTimeControl];
	}
	return self;
}

-(void) awakeFromNib {
	[super awakeFromNib];
	[self initTimeControl];
}

-(void) initTimeControl {
	[self registerCellClass:[RulerCellView class]];
	self.delegate = (id)self;
	self.dataSource = (id)self;
	self.timeInterval = 0;
	self.formattedTimeInterval = [self formatTimeIntervalValue:0];
}

static NSInteger valuesTable[] = {
	1, 5, 10, 15, 20, 25, 30, 45,
	1*60, 2*60, 3*60, 4*60, 5*60,
	10*60, 15*60, 20*60, 25*60, 30*60, 45*60,
	1*60*60, 2*60*60, 2.5*60*60, 3*60*60, 4*60*60, 5*60*60,
	10*60*60, 15*60*60, 20*60*60, 24*60*60
};
static const NSInteger valuesTableSize = sizeof(valuesTable)/sizeof(valuesTable[0]);

-(NSInteger) rulerValueAtIndex:(NSInteger)index {
	if (index >= valuesTableSize) {
		index = valuesTableSize -1;
	}
	return valuesTable[index];
}

-(NSString*) formatTimeIntervalValue:(NSTimeInterval)value {
	
	if (value < 10) { // < 10 sec
		value = round(value*10)/10;
		return [NSString stringWithFormat:@"%@s", @((float)value)];
	} else if (value < 60) { // < 1 min
		return [NSString stringWithFormat:@"%lds", (long)round(value)];
	} else if (value < 5*60) { // < 5 min
		NSInteger mins = (NSInteger)value / 60;
		NSInteger sec = (NSInteger)value % 60;
		if (sec > 0) {
			return [NSString stringWithFormat:@"%ldm %lds", (long)mins, (long)sec];
		} else {
			return [NSString stringWithFormat:@"%ldm", (long)mins];
		}
	} if (value < 60*60) { // < 1 h
		NSInteger mins = round(value/60);
		return [NSString stringWithFormat:@"%ldm", mins];
	} else  {
		NSInteger hrs = (NSInteger)value / 3600;
		NSInteger mins = round((value - hrs*3600) / 60);
		if (mins > 0) {
			return [NSString stringWithFormat:@"%ldh %ldm", (long)hrs, (long)mins];
		} else {
			return [NSString stringWithFormat:@"%ldh", (long)hrs];
		}
	}
	return nil;
}

-(CGFloat) selectedTimeIntervalValue {
	CGFloat cursorPos = self.leftMargin;
	CGFloat progress = [self progressValueAtDisplayPosition:cursorPos];
	NSInteger intPart = floor(progress);
	CGFloat decimalPart = progress - intPart;
	
	NSInteger value = [self rulerValueAtIndex:intPart];
	NSInteger nextValue = [self rulerValueAtIndex:intPart+1];
	CGFloat scaledDecimalPart = decimalPart*(nextValue-value);
	return value+scaledDecimalPart;
}


- (NSInteger)numberOfCellsInSliderView:(RulerSliderView*)sliderView {
	return valuesTableSize;
}

- (void)sliderView:(RulerSliderView*)sliderView prepareView:(RulerCellView*)view forCellAtIndex:(NSInteger)cellIndex {
	NSInteger value = [self rulerValueAtIndex:cellIndex];
	view.text = [self formatTimeIntervalValue:value];
	[view setNeedsDisplay];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat currentTimeIntervalValue = [self selectedTimeIntervalValue];
	if(self.timeInterval != currentTimeIntervalValue) {
		self.timeInterval = currentTimeIntervalValue;
		NSString* formattedTimeInterval = [self formatTimeIntervalValue:currentTimeIntervalValue];
		if(![self.formattedTimeInterval isEqualToString:formattedTimeInterval]) {
			self.formattedTimeInterval = formattedTimeInterval;
			if(self.onUpdateTimeHandler) {
				self.onUpdateTimeHandler(currentTimeIntervalValue, formattedTimeInterval);
			}
		}
	}
}


@end
