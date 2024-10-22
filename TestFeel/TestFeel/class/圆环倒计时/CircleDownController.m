//
//  CircleDownController.m
//  TestFeel
//
//  Created by app on 2023/9/12.
//

#import "CircleDownController.h"
#import "LFSAirProTopView.h"

@interface CircleDownController ()
@property(nonatomic,strong)LFSAirProTopView *topView;
@property(nonatomic,strong)UISlider *slider;
@end

@implementation CircleDownController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(30, 100, SCREEN_WIDTH - 60, 80)];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [slider addTarget:self action:@selector(slider:) forControlEvents:(UIControlEventValueChanged)];
    self.slider = slider;
    [self.view addSubview:slider];
    
    
    self.topView = [[LFSAirProTopView alloc]initWithFrame:CGRectMake(50, 180, 200, 200) midImg:@"AeroIns"];
    
    
    [self.view addSubview:self.topView];
}

-(IBAction)slider:(UISlider*)sender{
    NSLog(@"%f",sender.value);
    self.topView.circleSlider.value = sender.value;
//    if (sender.value > 0.3) {
//        self.topView.circleSlider.minimumTrackTintColor = [UIColor blueColor];
//    }
}

@end
