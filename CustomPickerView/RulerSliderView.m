//
//  RulerSliderView.m
//  RulerSliderView
//
//  Created by onegray on 6/18/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

#import "RulerSliderView.h"

@interface RulerSliderView()
@property (nonatomic, assign) NSInteger numberOfCells;
@property (nonatomic, strong) Class cellClass;

@property (nonatomic, strong) NSMutableArray* visibleCellViews;
@property (nonatomic, strong) NSMutableArray* cachedCellViews;

@property (nonatomic, assign) NSInteger firstViewIndex;
@property (nonatomic, assign) NSInteger lastViewIndex;
@end

@implementation RulerSliderView
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initControl];
	}
	return self;
}

-(void) awakeFromNib {
	[self initControl];
}

-(void) initControl {
	self.cachedCellViews = [NSMutableArray new];
	self.visibleCellViews = [NSMutableArray new];
	[self registerCellClass:[UIView class]];
	self.cellSize = CGSizeMake(50, self.bounds.size.height);
	self.leftMargin = self.bounds.size.width/2;
	self.rightMargin = self.bounds.size.width/2;
}

- (void)registerCellClass:(Class)aClass {
	NSAssert([aClass isSubclassOfClass:[UIView class]], @"Must be a subclass of UIView");
	self.cellClass = aClass;
}

-(void)setCellSize:(CGSize)cellSize {
	if(!CGSizeEqualToSize(_cellSize, cellSize)) {
		_cellSize = cellSize;
		if (self.numberOfCells > 0) {
			[self resetContent];
		}
	}
}

-(void) setLeftMargin:(CGFloat)leftMargin {
	if(_leftMargin != leftMargin) {
		_leftMargin = leftMargin;
		if (self.numberOfCells > 0) {
			[self resetContent];
		}
	}
}

-(void) setRightMargin:(CGFloat)rightMargin {
	if (_rightMargin != rightMargin) {
		_rightMargin = rightMargin;
		if (self.numberOfCells > 0) {
			[self resetContent];
		}
	}
}

-(void) layoutSubviews {
	[super layoutSubviews];
	if (self.numberOfCells == 0) {
		[self resetContent];
	}
}

-(void) resetContent {
	[self.visibleCellViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	[self.visibleCellViews removeAllObjects];

	self.numberOfCells = [self.dataSource numberOfCellsInSliderView:self];
	CGFloat contentWidth = self.leftMargin + self.cellSize.width*self.numberOfCells + self.rightMargin;
	self.contentSize = CGSizeMake(contentWidth, self.bounds.size.height);
	
	if(self.numberOfCells > 0) {
		self.firstViewIndex = [self calcFirstVisibleIndex];
		self.lastViewIndex = [self calcLastVisibleIndex];
		self.visibleCellViews = [self addCellViewsFromIndex:self.firstViewIndex toIndex:self.lastViewIndex];
		
		if([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
			[self.delegate scrollViewDidScroll:self];
		}
	}
}

-(UIView*) dequeueOrCreateViewForCell {
	UIView* v = nil;
	if(self.cachedCellViews.count > 0) {
		v = [self.cachedCellViews lastObject];
		[self.cachedCellViews removeLastObject];
	} else {
		v = [[self.cellClass alloc] initWithFrame:CGRectMake(0, 0, self.cellSize.width, self.cellSize.height)];
	}
	return v;
}

-(NSInteger) calcFirstVisibleIndex {
	NSAssert(self.numberOfCells>0, @"Must be initialized with valid number of cells");
	NSInteger index = floor( (self.contentOffset.x - self.leftMargin) / self.cellSize.width);
	if(index < 0) {
		index = 0;
	} else if(index >= self.numberOfCells) {
		index = self.numberOfCells-1;
	}
	return index;
}

-(NSInteger) calcLastVisibleIndex {
	NSAssert(self.numberOfCells>0, @"Must be initialized with valid number of cells");
	NSInteger index = ceil((self.contentOffset.x - self.leftMargin + self.bounds.size.width) / self.cellSize.width);
	if(index < 0) {
		index = 0;
	} else if(index >= self.numberOfCells) {
		index = self.numberOfCells-1;
	}
	return index;
}

-(NSMutableArray*) addCellViewsFromIndex:(NSInteger)startIndex toIndex:(NSInteger)endIndex {
	NSMutableArray* addedCells = [NSMutableArray arrayWithCapacity:endIndex-startIndex+1];
	for(NSInteger i = startIndex; i <= endIndex; i++ ) {
		UIView* v = [self dequeueOrCreateViewForCell];
		CGFloat xPos = self.leftMargin + i*self.cellSize.width;
		v.transform = CGAffineTransformIdentity;
		v.frame = CGRectMake(xPos, 0, self.cellSize.width, self.cellSize.height);
		if([self.delegate respondsToSelector:@selector(sliderView:prepareView:forCellAtIndex:)]) {
			[self.delegate sliderView:self prepareView:v forCellAtIndex:i];
		}
		[self addSubview:v];
		[addedCells addObject:v];
	}
	return addedCells;
}

-(void) removeCellViews:(NSArray*)cellViews {
	for(UIView* v in cellViews) {
		[v removeFromSuperview];
		[self.cachedCellViews addObject:v];
	}
}

-(void) updateVisibleCells {
	NSInteger updatedFirstIndex = [self calcFirstVisibleIndex];
	if(updatedFirstIndex < self.firstViewIndex) {
		NSArray* addedCells = [self addCellViewsFromIndex:updatedFirstIndex toIndex:self.firstViewIndex-1];
		NSRange rangeToAdd = NSMakeRange(0, self.firstViewIndex-updatedFirstIndex);
		[self.visibleCellViews insertObjects:addedCells atIndexes:[NSIndexSet indexSetWithIndexesInRange:rangeToAdd]];
		self.firstViewIndex = updatedFirstIndex;
	} else if (self.firstViewIndex < updatedFirstIndex){
		NSRange rangeToRemove = NSMakeRange(0, updatedFirstIndex-self.firstViewIndex);
		[self removeCellViews:[self.visibleCellViews objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:rangeToRemove]]];
		[self.visibleCellViews removeObjectsInRange:rangeToRemove];
		self.firstViewIndex = updatedFirstIndex;
	}
	
	NSInteger updatedLastIndex = [self calcLastVisibleIndex];
	if(self.lastViewIndex < updatedLastIndex) {
		NSArray* addedCells = [self addCellViewsFromIndex:self.lastViewIndex+1 toIndex:updatedLastIndex];
		[self.visibleCellViews addObjectsFromArray:addedCells];
		self.lastViewIndex = updatedLastIndex;
	} else if (updatedLastIndex < self.lastViewIndex) {
		NSRange rangeToRemove = NSMakeRange(updatedLastIndex-self.firstViewIndex+1, self.lastViewIndex-updatedLastIndex);
		[self removeCellViews:[self.visibleCellViews objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:rangeToRemove]]];
		[self.visibleCellViews removeObjectsInRange:rangeToRemove];
		self.lastViewIndex = updatedLastIndex;
	}
	NSAssert(self.lastViewIndex-self.firstViewIndex+1 == self.visibleCellViews.count, @"Invalid logic");
}

-(void) setContentOffset:(CGPoint)contentOffset {
	[super setContentOffset:contentOffset];
	if (self.contentSize.width > 0 && self.visibleCellViews.count > 0) {
		[self updateVisibleCells];
	}
}

-(CGFloat) progressValueAtDisplayPosition:(CGFloat)displayPosition {
	CGFloat absolutePosition = self.contentOffset.x - self.leftMargin + displayPosition;
	return [self progressValueAtAbsolutePosition:absolutePosition];
}

-(CGFloat) progressValueAtAbsolutePosition:(CGFloat)absolutePosition {
	if (absolutePosition < 0) {
		absolutePosition = 0;
	} else if (absolutePosition > self.numberOfCells * self.cellSize.width) {
		absolutePosition = self.numberOfCells * self.cellSize.width;
	}
	int cellIndex = floor(absolutePosition / self.cellSize.width);
	CGFloat posInCell = absolutePosition - cellIndex*self.cellSize.width;
	CGFloat progressInCell = posInCell / self.cellSize.width;
	return cellIndex + progressInCell;
}

@end





















