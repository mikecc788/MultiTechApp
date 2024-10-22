//
//  LFSCircleSlider.m
//  TestCircle
//
//  Created by cl on 2022/3/12.
//  Copyright © 2022 KSB. All rights reserved.
//

#import "LFSCircleSlider.h"



@interface LFSCircleSlider()
@property (nonatomic, assign) CGPoint circleStartPoint; //thumb起始位置

@property (nonatomic, assign) CGFloat radius;           //半径
@property (nonatomic, assign) CGPoint drawCenter;       //绘制圆的圆心

@property (nonatomic, assign) CGFloat angle;            //转过的角度

@property (nonatomic, assign) BOOL lockClockwise;       //禁止顺时针转动
@property (nonatomic, assign) BOOL lockAntiClockwise;   //禁止逆时针转动
@property (nonatomic, assign) BOOL interaction;
@property (nonatomic, strong) UIImage *startImg;
@property (nonatomic, strong) UIImage *endImg;
@end
@implementation LFSCircleSlider
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"angle"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
/**
 设定默认值
 */
- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.circleRadius = MIN(self.frame.size.width, self.frame.size.height) - 24;
    self.circleBorderWidth = 15.0f;
    self.maximumTrackTintColor = XTAY_RGB(247,237,244);
    self.minimumTrackTintColor = [UIColor blueColor];
    
    self.startImg = [UIImage imageNamed:@"alarm"];
    self.endImg = [UIImage imageNamed:@"alarm"];
    self.drawCenter = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
   self.circleStartPoint = CGPointMake(self.drawCenter.x, self.drawCenter.y - self.circleRadius);
    self.loadProgress = 1.0;
    self.interaction = NO;
    self.canRepeat = NO;
    self.angle = 0;
    self.lockAntiClockwise = YES;
    self.lockClockwise = NO;
    
    [self addObserver:self
           forKeyPath:@"angle"
              options:NSKeyValueObservingOptionNew
              context:nil];
}

#pragma mark - drwRect

- (void)drawRect:(CGRect)rect {
    self.drawCenter = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    self.radius = self.circleRadius;
     self.circleStartPoint = CGPointMake(self.drawCenter.x, self.drawCenter.y - self.circleRadius);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //圆形的背景颜色
       CGContextSetStrokeColorWithColor(ctx, self.backgroundTintColor.CGColor);
       CGContextSetLineWidth(ctx, self.circleBorderWidth);
       CGContextAddArc(ctx, self.drawCenter.x, self.drawCenter.y, self.radius, 0, 2 * M_PI, 0);
       CGContextDrawPath(ctx, kCGPathStroke);
    
    //加载的进度
//    UIBezierPath *loadPath = [UIBezierPath bezierPath];
//    CGFloat loadStart = -M_PI_2;
//    CGFloat loadCurre = loadStart + 2 * M_PI * self.loadProgress;
//    
//    [loadPath addArcWithCenter:self.drawCenter
//                        radius:self.radius
//                    startAngle:loadStart
//                      endAngle:loadCurre
//                     clockwise:YES];
//    CGContextSaveGState(ctx);
//    CGContextSetShouldAntialias(ctx, YES);
//    CGContextSetLineWidth(ctx, self.circleBorderWidth);
//    CGContextSetStrokeColorWithColor(ctx, self.maximumTrackTintColor.CGColor);
//    CGContextAddPath(ctx, loadPath.CGPath);
//    CGContextDrawPath(ctx, kCGPathStroke);
//    CGContextRestoreGState(ctx);
//    //起始位置做圆滑处理
//    CGContextSaveGState(ctx);
//    CGContextSetShouldAntialias(ctx, YES);
//    CGContextSetFillColorWithColor(ctx, self.minimumTrackTintColor.CGColor);
//    CGContextAddArc(ctx, self.circleStartPoint.x, self.circleStartPoint.y, self.circleBorderWidth / 2.0, 0, M_PI * 2, 0);
//    CGContextDrawPath(ctx, kCGPathFill);
//    CGContextRestoreGState(ctx);
    
    //value
//    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    CGFloat originstart = -M_PI_2;
    CGFloat currentOrigin = originstart + 2 * M_PI * self.value;
//    [circlePath addArcWithCenter:self.drawCenter
//                          radius:self.radius
//                      startAngle:originstart
//                        endAngle:currentOrigin
//                       clockwise:YES];
//    CGContextSaveGState(ctx);
//    CGContextSetShouldAntialias(ctx, YES);
//    CGContextSetLineWidth(ctx, self.circleBorderWidth);
//    CGContextSetStrokeColorWithColor(ctx, self.minimumTrackTintColor.CGColor);
//    CGContextAddPath(ctx, circlePath.CGPath);
//    CGContextDrawPath(ctx, kCGPathStroke);
//    CGContextRestoreGState(ctx);
    
    // 绘制 startIcon
//       if (self.startImg) {
//           CGPoint startPoint = [self pointOnCircleWithCenter:self.drawCenter
//                                                        radius:self.radius
//                                                        angle:loadStart];
//           CGRect startIconRect = CGRectMake(startPoint.x - self.startImg.size.width / 2,
//                                             startPoint.y - self.startImg.size.height / 2,
//                                             self.startImg.size.width,
//                                             self.startImg.size.height);
//           [self.startImg drawInRect:startIconRect];
//       }
//
//       // 绘制 endIcon
       if (self.endImg) {
           CGPoint endPoint = [self pointOnCircleWithCenter:self.drawCenter
                                                      radius:self.radius
                                                      angle:currentOrigin];
           CGRect endIconRect = CGRectMake(endPoint.x - self.endImg.size.width / 2,
                                           endPoint.y - self.endImg.size.height / 2,
                                           self.endImg.size.width,
                                           self.endImg.size.height);
           [self.endImg drawInRect:endIconRect];
       }
    
}

- (CGPoint)pointOnCircleWithCenter:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle {
    CGFloat x = center.x + radius * cos(angle);
    CGFloat y = center.y + radius * sin(angle);
    return CGPointMake(x, y);
}

#pragma mark - setter
- (void)setValue:(float)value {
    if (value < 0.25) {
        self.lockClockwise = NO;
    } else {
        self.lockAntiClockwise = NO;
    }
    _value = MIN(MAX(value, 0.0), 0.997648);
    [self setNeedsDisplay];
}

- (void)setCanRepeat:(BOOL)canRepeat {
    _canRepeat = canRepeat;
    [self setNeedsDisplay];
}

- (void)setLoadProgress:(float)loadProgress {
    _loadProgress = loadProgress;
    [self setNeedsDisplay];
}

- (void)setCircleRadius:(CGFloat)circleRadius {
    _circleRadius = circleRadius;
    self.circleStartPoint = CGPointMake(self.drawCenter.x, self.drawCenter.y - self.circleRadius);
    [self setNeedsDisplay];
}

- (void)setCircleBorderWidth:(CGFloat)circleBorderWidth {
    _circleBorderWidth = circleBorderWidth;
    [self setNeedsDisplay];
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    _minimumTrackTintColor = minimumTrackTintColor;
    [self setNeedsDisplay];
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    _maximumTrackTintColor = maximumTrackTintColor;
    [self setNeedsDisplay];
}


@end
