//
//  KSBatteryView.m
//  FastPair
//
//  Created by cl on 2019/7/26.
//  Copyright © 2019 KSB. All rights reserved.
//

#import "KSBatteryView.h"
#define RGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1]
@interface KSBatteryView()
@property(nonatomic,strong)UIView *batteryV;
@property(nonatomic,strong)UIView *batterV;
/** 线宽 */
@property (nonatomic, assign) CGFloat lineW;
@end

@implementation KSBatteryView

-(instancetype)initWithFrame:(CGRect)frame num:(NSInteger)num {
    if (self = [super initWithFrame:frame]) {
       
        self.backgroundColor = RGB(223, 195, 251);
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
//        UILabel *lab = [[UILabel alloc]init];
//        lab.text = @"电池";
//        [self addSubview:lab];
        CGFloat batteryW = 80;
        CGFloat batteryH = 40;
        UIView *batterV = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width - batteryW -20, 10, batteryW, batteryH)];
        self.batterV = batterV;
        [self addSubview:batterV];
        [self creatBatteryView:num];
        
    }
    return self;
}
- (void)creatBatteryView:(NSInteger)num{
    // 电池的宽度
    CGFloat w = self.batterV.bounds.size.width;
    // 电池的高度
    CGFloat h = self.batterV.bounds.size.height;
    // 电池的x的坐标
    CGFloat x = self.batterV.bounds.origin.x;
    // 电池的y的坐标
    CGFloat y = self.batterV.bounds.origin.y;
    // 电池的线宽
    self.lineW = 3;
    // 画电池
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(x, y, w, h) cornerRadius:2];
    CAShapeLayer *batteryLayer = [CAShapeLayer layer];
    batteryLayer.lineWidth = self.lineW;
    if(num <= 40 && num > 20){
        batteryLayer.strokeColor = [UIColor colorWithHexString:@"#F38911"].CGColor;
    }else if(num <= 20){
        batteryLayer.strokeColor = [UIColor redColor].CGColor;
    }else{
        batteryLayer.strokeColor = [UIColor colorWithHexString:@"#006400"].CGColor;
    }
    
    
    batteryLayer.fillColor = [UIColor clearColor].CGColor;
    batteryLayer.path = [path1 CGPath];
    [self.batterV.layer addSublayer:batteryLayer];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(x+w+self.lineW, y+h/3)];
    [path2 addLineToPoint:CGPointMake(x+w+self.lineW, y+h*2/3)];
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.lineWidth = self.lineW;
    if(num <= 40 && num > 20){
        layer2.strokeColor = [UIColor colorWithHexString:@"#F38911"].CGColor;
    }else if(num <= 20){
        layer2.strokeColor = [UIColor redColor].CGColor;
    }else{
        layer2.strokeColor = [UIColor colorWithHexString:@"#006400"].CGColor;
    }
    layer2.fillColor = [UIColor clearColor].CGColor;
    layer2.path = [path2 CGPath];
    [self.batterV.layer addSublayer:layer2];
    [self setBatteryNum:num];
}

-(void)setBatteryNum:(float)num{
    [self.batteryV removeFromSuperview];
    NSLog(@"num==%f",num);
    CGFloat spaceW = 5;
    // 电池的高度
    CGFloat h = self.batterV.bounds.size.height;
    // 电池的x的坐标
    CGFloat x = self.batterV.bounds.origin.x;
    // 电池的y的坐标
    CGFloat y = self.batterV.bounds.origin.y;
    CGFloat batteryViewxX = num > 0 ? (x+spaceW):x;
    UIView *batteryView = [[UIView alloc]initWithFrame:CGRectMake(batteryViewxX,y+_lineW, num -batteryViewxX*2, h-_lineW*2)];
    self.batteryV = batteryView;
   batteryView.layer.cornerRadius = 2;
    if(num <= 40 && num > 20){
        batteryView.backgroundColor = [UIColor colorWithHexString:@"#F38911"];
    }else if(num <= 20){
        batteryView.backgroundColor = [UIColor redColor];
    }else{
        batteryView.backgroundColor = [UIColor colorWithHexString:@"#1A850F"];
    }
   
   [self.batterV addSubview:batteryView];
    [self.batterV layoutSubviews];
}

@end
