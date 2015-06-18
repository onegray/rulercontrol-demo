//
//  RulerCellView.m
//  CustomPickerView
//
//  Created by onegray on 6/18/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

#import "RulerCellView.h"

@implementation RulerCellView

- (instancetype)initWithFrame:(CGRect)frame

{
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (void)drawRect:(CGRect)rect {

	CGFloat longTickWidth = 2;
	CGFloat shortTickWidth = 1;
	
	CGSize contentSize = self.bounds.size;
	CGFloat longTickHeight = 0.45 * contentSize.height;
	CGFloat longTickOffset = 0.5 * contentSize.width - longTickWidth;
	CGFloat shortTickHeight = 0.5 * longTickHeight;
	CGFloat shortTickOffset = contentSize.width - shortTickWidth;
	CGFloat textHeight = contentSize.height - longTickHeight;
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();

	CGContextSetLineWidth(ctx, longTickWidth);
	CGContextMoveToPoint(ctx, longTickOffset, 0);
	CGContextAddLineToPoint(ctx, longTickOffset, longTickHeight);
	CGContextClosePath(ctx);
	CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
	CGContextDrawPath(ctx, kCGPathFillStroke);
	
	CGContextSetLineWidth(ctx, shortTickWidth);
	CGContextMoveToPoint(ctx, shortTickOffset, 0);
	CGContextAddLineToPoint(ctx, shortTickOffset, shortTickHeight);
	CGContextClosePath(ctx);
	CGContextSetStrokeColorWithColor(ctx, [[UIColor lightGrayColor] CGColor]);
	CGContextDrawPath(ctx, kCGPathFillStroke);
	
	CGRect textRect = CGRectMake(0, longTickHeight, contentSize.width, textHeight);
	NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	paragraphStyle.alignment = NSTextAlignmentCenter;
	NSDictionary* textAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:floor(0.6*textHeight)],
							   NSParagraphStyleAttributeName : paragraphStyle};
	
	[self.text drawInRect:textRect withAttributes:textAttr];
}

@end
