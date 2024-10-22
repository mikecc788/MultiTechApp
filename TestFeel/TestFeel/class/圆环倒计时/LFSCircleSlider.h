//
//  LFSCircleSlider.h
//  TestCircle
//
//  Created by cl on 2022/3/12.
//  Copyright © 2022 KSB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CircleConfigure;
NS_ASSUME_NONNULL_BEGIN

@interface LFSCircleSlider : UIView
@property (nullable, nonatomic, strong) UIColor *backgroundTintColor;   //圆环的背景色
@property (nullable, nonatomic, strong) UIColor *minimumTrackTintColor; //圆环滑过的颜色
@property (nullable, nonatomic, strong) UIColor *maximumTrackTintColor; //圆环加载进度的颜色，加载完成后就相当于圆环未滑过的颜色
@property (nonatomic, assign) CGFloat circleBorderWidth;    //圆的宽度
@property (nonatomic, assign) CGFloat circleRadius;         //圆形进度条的半径，一般比view的宽高中最小者还要小24
@property (nonatomic, assign) BOOL canRepeat;               //是否可以重复拖动。默认为NO，即只能转到360；否则任意角度。

@property (nonatomic, assign) float value;                  //slider当前的value
@property (nonatomic, assign) float loadProgress;           //slider加载的进度

@property (nonatomic, strong) NSString *startIcon;
@property (nonatomic, strong) NSString *endIcon;
@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
- (instancetype)initWithFrame:(CGRect)frame configure:(CircleConfigure *)configure;
@end

NS_ASSUME_NONNULL_END
