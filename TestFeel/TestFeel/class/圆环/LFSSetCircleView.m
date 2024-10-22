//
//  LFSSetCircleView.m
//  AirSmart
//
//  Created by app on 2023/2/21.
//

#import "LFSSetCircleView.h"
#define Set_Circle_Color [UIColor colorFromHexStr:@"#5EB884"]

#define RGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1]

@interface LFSSetCircleView (){
    
    CAShapeLayer *_progressLayer;
    CGFloat _radius;
    CGFloat _centerX;
    CGFloat _centerY;
    
    
}
@property(nonatomic,strong)CATextLayer *textLayer;
@property(nonatomic,assign)CGFloat lineWidth;
@end

@implementation LFSSetCircleView

-(instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _radius = (frame.size.width - lineWidth)/2;
        _centerX = frame.size.width/2;
        _centerY = frame.size.height/2;
        self.lineWidth = lineWidth;
        [self drawBackgroundCircleView];
//        [self drawProgressCircleView];
//        [self addSubview:self.scoreLB];
    }
    return self;
}
//绘制背景圆环
- (void)drawBackgroundCircleView
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY) radius:_radius startAngle:-0.5*M_PI endAngle:1.5*M_PI clockwise:YES];
    
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.path = path.CGPath;
    backLayer.strokeColor = Set_Circle_Color.CGColor;
    backLayer.fillColor = [UIColor clearColor].CGColor;
    backLayer.lineWidth = self.lineWidth;
    backLayer.strokeEnd = 1;
    [self.layer  addSublayer:backLayer];
    
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 5);
    
    textLayer.bounds = CGRectMake(0, 0, self.frame.size.width -10, 30);
    textLayer.string = @"Hello";
    //设置文字的字体
    textLayer.fontSize = 20;
    textLayer.alignmentMode = kCAAlignmentCenter;
    //设置文字的颜色
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    //添加文字图层到圆环图层上
    [self.layer addSublayer:textLayer];
    self.textLayer = textLayer;
    CATextLayer *textLayer2 = [CATextLayer layer];
    textLayer2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 10 + 15);
    
    textLayer2.bounds = CGRectMake(0, 0, self.frame.size.width -10, 30);
    textLayer2.string = @"L/m";
    //设置文字的字体
    textLayer2.fontSize = 16;
    textLayer2.alignmentMode = kCAAlignmentCenter;
    //设置文字的颜色
    textLayer2.foregroundColor = [UIColor blackColor].CGColor;
    //添加文字图层到圆环图层上
    [self.layer addSublayer:textLayer2];
}
//绘制进度圆环
- (void)drawProgressCircleView
{
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY) radius:_radius startAngle:-0.5*M_PI endAngle:1.5*M_PI clockwise:YES];

    //创建进度layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    //指定path的渲染颜色
    _progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = self.lineWidth;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeStart = 0;
    //设置渐变颜色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[RGB(48, 159, 217) CGColor],(id)[RGB(166, 234, 240) CGColor], nil]];
    gradientLayer.startPoint = CGPointMake(1, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];

}
-(void)setValue:(NSString *)value{
    self.textLayer.string = [NSString stringWithFormat:@"%@",value];
}
@end
