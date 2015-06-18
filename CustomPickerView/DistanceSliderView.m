//
//  DistanceSliderView.m
//  CustomPickerView
//
//  Created by onegray on 6/18/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

#import "DistanceSliderView.h"
#import "RulerCellView.h"

@interface DistanceSliderView()
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, strong) NSString* formattedDistance;
@end

@implementation DistanceSliderView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initDistanceControl];
	}
	return self;
}

-(void) awakeFromNib {
	[super awakeFromNib];
	[self initDistanceControl];
}

-(void) initDistanceControl {
	[self registerCellClass:[RulerCellView class]];
	self.delegate = (id)self;
	self.dataSource = (id)self;
	self.distance = 0;
	self.formattedDistance = [self formatDistanceValue:0];
}

-(NSInteger) rulerValueAtIndex:(NSInteger)index {
	//	values:
	//	1	2	3	4	5	6	7	8	9
	//	10	20	30	40	50	60	70	80	90
	//	100	200	300	400	500	600	700	800	900
	//	...
	
	NSInteger power = index / 9;
	NSInteger base = pow(10, power);
	NSInteger value = index % 9 + 1;
	return base*value;
}

-(NSString*) formatDistanceValue:(CGFloat)value {
	if (value < 10) {
		value = round(value*100) / 100;
		return [NSString stringWithFormat:@"%@m", @((float)value)];
	} else if (value < 1000) {
		return [NSString stringWithFormat:@"%@m", @((float)round(value))];
	} else {
		value = value / 1000;
		value = round(value*100) / 100;
		if(value > 10) {
			value = 10;
		}
		return [NSString stringWithFormat:@"%@km", @((float)value)];
	}
}

-(CGFloat) selectedDistanceValue {
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
	return 37; // for 10 km max
}

- (void)sliderView:(RulerSliderView*)sliderView prepareView:(RulerCellView*)view forCellAtIndex:(NSInteger)cellIndex {	NSInteger value = [self rulerValueAtIndex:cellIndex];
	view.text = [self formatDistanceValue:value];
	[view setNeedsDisplay];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat currentDistanceValue = [self selectedDistanceValue];
	if(self.distance != currentDistanceValue) {
		self.distance = currentDistanceValue;
		NSString* formattedDistance = [self formatDistanceValue:currentDistanceValue];
		if(![self.formattedDistance isEqualToString:formattedDistance]) {
			self.formattedDistance = formattedDistance;
			if(self.onUpdateDistanceHandler) {
				self.onUpdateDistanceHandler(currentDistanceValue, formattedDistance);
			}
		}
	}
	[self updatePerspective];
}

-(void) updatePerspective {
	for (RulerCellView* cellView in self.visibleCellViews) {
		CGFloat offset = cellView.frame.origin.x - self.contentOffset.x;
		offset -= self.bounds.size.width / 2 - self.cellSize.width / 2;
		CGFloat k = fabs(offset) / self.bounds.size.width;
		CGFloat scale = 1.0 - 0.7*k*k;
		
		CGFloat h = cellView.frame.size.height;
		CGAffineTransform t = CGAffineTransformMakeTranslation(0, -0.4*(1.0-scale)*h);
		t = CGAffineTransformScale(t, scale, scale);
		cellView.transform = t;
		
		cellView.alpha = scale*scale;
	}
}


@end
