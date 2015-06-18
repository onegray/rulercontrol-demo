//
//  RulerSliderView.h
//  RulerSliderView
//
//  Created by onegray on 6/18/15.
//  Copyright (c) 2015 onegray. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RulerSliderView;

@protocol RulerSliderViewDataSource <NSObject>
@required
- (NSInteger)numberOfCellsInSliderView:(RulerSliderView*)sliderView;
@end

@protocol RulerSliderViewDelegate <NSObject>
@required
- (void)sliderView:(RulerSliderView*)sliderView prepareView:(UIView*)view forCellAtIndex:(NSInteger)cellIndex;
@end



@interface RulerSliderView : UIScrollView

@property(nonatomic, assign) id<RulerSliderViewDataSource> dataSource;
@property(nonatomic, assign) id<RulerSliderViewDelegate, UIScrollViewDelegate> delegate;

@property(nonatomic, assign) CGSize cellSize;
@property(nonatomic, assign) CGFloat leftMargin;
@property(nonatomic, assign) CGFloat rightMargin;

- (void)registerCellClass:(Class)aClass;

-(CGFloat) progressValueAtDisplayPosition:(CGFloat)displayPosition;
-(CGFloat) progressValueAtAbsolutePosition:(CGFloat)absolutePosition;


@property (nonatomic, strong, readonly) NSMutableArray* visibleCellViews;
@property (nonatomic, assign, readonly) NSInteger numberOfCells;

@end




