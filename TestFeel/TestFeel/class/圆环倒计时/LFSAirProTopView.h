//
//  LFSAirProTopView.h
//  FeelLife
//
//  Created by app on 2022/9/26.
//

#import <UIKit/UIKit.h>
#import "LFSCircleSlider.h"
NS_ASSUME_NONNULL_BEGIN

@interface LFSAirProTopView : UIView
-(instancetype)initWithFrame:(CGRect)frame midImg:(NSString*)img;
@property (nonatomic, strong) LFSCircleSlider *circleSlider;
@property (nonatomic, strong) UILabel *falseL;
@end

NS_ASSUME_NONNULL_END
