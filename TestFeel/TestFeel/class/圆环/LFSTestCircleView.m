//
//  LFSTestCircleView.m
//  AirSmart
//
//  Created by app on 2023/3/24.
//

#import "LFSTestCircleView.h"

@interface LFSTestCircleView ()<CAAnimationDelegate>
@property(nonatomic,assign)CGFloat lineW;
@property(nonatomic,strong)CAShapeLayer *progressLayer;
@property (nonatomic, strong) CATextLayer *textLayer;
@end

@implementation LFSTestCircleView

-(instancetype)initWithFrame:(CGRect)frame width:(CGFloat)lineWidth{
    if(self = [super initWithFrame:frame]){
        self.lineW = lineWidth;
        [self drawCircleView];
    }
    return self;
}

-(void)drawCircleView{
    // 创建一个圆环进度条
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    CGFloat lineWidth = self.lineW;
    CGFloat radius = self.width / 2;
    CGPoint centerPoint = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:centerPoint radius:radius startAngle:0 endAngle:0 clockwise:YES];
    progressLayer.path = circlePath.CGPath;
 
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.lineWidth = lineWidth;
    [self.layer addSublayer:progressLayer];
    self.progressLayer = progressLayer;
    
    // 添加一个用于显示进度的百分比文字
    CATextLayer *textLayer = [CATextLayer layer];
    
    
    textLayer.bounds = CGRectMake(0, 0, self.width, 20);
    textLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0 );
    
//    textLayer.frame = CGRectMake(centerPoint.x - radius, centerPoint.y - radius, radius*2, radius*2);
    textLayer.fontSize = 14;
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.string = @"0%";
    self.textLayer = textLayer;
    [self.layer addSublayer:textLayer];
    
}

-(void)setCircleColor:(UIColor *)circleColor{
    self.progressLayer.strokeColor = circleColor.CGColor;
}

- (void)setProgressValue:(CGFloat)progressValue {
    _progressValue = progressValue;

    // 更新百分比文字
    NSString *text = [NSString stringWithFormat:@"%.0f%%", progressValue * 100.0f];
    self.textLayer.string = text;
    // 更新圆环进度
    self.progressLayer.strokeEnd = progressValue;
    // 计算圆环结束的角度
    CGFloat endAngle = M_PI*2 * progressValue - M_PI_2;

    // 更新圆环路径
   UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0)
                                                             radius:self.width * 0.5
                                                         startAngle:-M_PI_2
                                                           endAngle:endAngle
                                                          clockwise:YES];
    self.progressLayer.path = circlePath.CGPath;

      // 更新圆环进度
      self.progressLayer.strokeEnd = progressValue;
}

@end
