//
//  SliderController.m
//  TestFeel
//
//  Created by app on 2023/2/3.
//

#import "SliderController.h"
#import "StepSlider.h"
#define MidLabelWidth 40
static NSTimeInterval lastTime = 0;

@interface SliderController ()

@property (nonatomic, strong) UILabel *valueLabel;

@property(nonatomic,strong)StepSlider *sliderView; ;
@end

@implementation SliderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 滑动条slider
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 250) / 2, 200, 250, 20)];
    slider.minimumValue = 1;// 设置最小值
    slider.maximumValue = 5;// 设置最大值
    slider.value = (slider.minimumValue + slider.maximumValue) / 2;
   // slider.continuous = YES;// 设置可连续变化
    slider.minimumTrackTintColor = [UIColor greenColor]; //滑轮左边颜色，如果设置了左边的图片就不会显示
    slider.maximumTrackTintColor = [UIColor redColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    [slider addTarget:self action:@selector(sliderEndValue:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:slider];
    // 当前值label
    self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.origin.x +250, slider.frame.origin.y - 30, MidLabelWidth, 20)];
    self.valueLabel.textAlignment = NSTextAlignmentCenter;
    self.valueLabel.text = [NSString stringWithFormat:@"%.0f", slider.value];
    [self.view addSubview:self.valueLabel];
    
    // 最小值label
    UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.origin.x - 30, slider.frame.origin.y - 30, 30, 20)];
    minLabel.textAlignment = NSTextAlignmentCenter;
    minLabel.text = [NSString stringWithFormat:@"%.0f", slider.minimumValue];
    [self.view addSubview:minLabel];
    
    // 最大值label
//    UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.origin.x + slider.frame.size.width + 5, slider.frame.origin.y, 30, 20)];
//    maxLabel.textAlignment = NSTextAlignmentLeft;
//    maxLabel.text = [NSString stringWithFormat:@"%.0f", slider.maximumValue];
//    [self.view addSubview:maxLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    btn.backgroundColor = [UIColor orangeColor];
    btn.layer.cornerRadius = 5;
    [btn setTitle:@"Button" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    self.sliderView = [[StepSlider alloc] initWithFrame:CGRectMake(20.f, 300.f, 300.f, 44.f)];
    [self.sliderView  setMaxCount:5];
    [self.sliderView  setIndex:2];
    
    [self.sliderView setTrackColor:[UIColor orangeColor]];
    [self.sliderView addTarget:self action:@selector(changeValue:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.sliderView addTarget:self action:@selector(endValue:) forControlEvents:(UIControlEventValueChanged)];
    [self.sliderView addTarget:self action:@selector(value1:) forControlEvents:(UIControlEventTouchDragInside)];
    [self.sliderView addTarget:self action:@selector(value2:) forControlEvents:(UIControlEventTouchDragOutside)];
//    [self.sliderView setExclusiveTouch:YES];
    self.sliderView.tintColor = [UIColor redColor];
    [self.view addSubview:self.sliderView];
    
    
}
- (IBAction)changeValue:(StepSlider *)sender{
    NSLog(@"Selected index: %lu",(unsigned long)sender.index + 1);
}
- (IBAction)value1:(StepSlider *)sender{
//    NSLog(@"value1");
}
- (IBAction)value2:(StepSlider *)sender{
    NSLog(@"value2");
}
- (IBAction)endValue:(StepSlider *)sender{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSLog(@"currentTime = %f lastTime=%f",currentTime,lastTime);
    if (currentTime - lastTime > 1){
        //1s执行一次
        lastTime = currentTime;
//        NSLog(@"点击事件执行");
        NSLog(@"endValue index: %lu",(unsigned long)sender.index + 1);
    }else{
        NSLog(@"发送数据太快");
    }
    
}
// 在按钮的TouchDown事件中实现
- (IBAction)buttonTouchDown:(UIButton *)sender {
    // 设置按钮的颜色
    sender.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    // 缩放
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }];
}
// 在按钮的TouchUpInside事件中实现
- (IBAction)buttonTouchUpInside:(UIButton *)sender {
    // 恢复原样
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformIdentity;
        sender.backgroundColor = [UIColor orangeColor];
    }];
    
    [self.sliderView setIndex:4];
    
}
-(void)sliderEndValue:(UISlider*)slider{
    NSLog(@"end ");
}
// slider变动时改变label值
- (void)sliderValueChanged:(UISlider*)slider {
    NSUInteger index = (NSUInteger)(slider.value );
    [slider setValue:index animated:NO];
//    int value = (int)slider.value;
//    NSLog(@"x=%f ee=%f ",slider.frame.origin.x +250*(slider.value/50),slider.value/50.0);
    self.valueLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)index];
//    self.valueLabel.x = slider.frame.origin.x +250*(slider.value/5) - MidLabelWidth*0.5;
//    if(slider.value > 25){
//        self.valueLabel.x = slider.frame.origin.x +250*(slider.value/5) - MidLabelWidth*0.5 - 4;
//    }else{
//        self.valueLabel.x = slider.frame.origin.x +250*(slider.value/5) - MidLabelWidth*0.5 + 4;
//    }
    
}

@end
