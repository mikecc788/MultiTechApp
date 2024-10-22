//
//  LFSTestCircleView.h
//  AirSmart
//
//  Created by app on 2023/3/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LFSTestCircleView : UIView
-(instancetype)initWithFrame:(CGRect)frame width:(CGFloat)lineWidth;
@property(nonatomic,strong)UIColor *circleColor;
@property (nonatomic, assign) CGFloat progressValue;
@end

NS_ASSUME_NONNULL_END
