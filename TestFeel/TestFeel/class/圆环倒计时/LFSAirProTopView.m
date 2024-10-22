//
//  LFSAirProTopView.m
//  FeelLife
//
//  Created by app on 2022/9/26.
//

#import "LFSAirProTopView.h"
#import "CircleConfigure.h"
#define TYColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface LFSAirProTopView()
@property(nonatomic,strong)UIImageView *midImg;

@end

@implementation LFSAirProTopView

-(instancetype)initWithFrame:(CGRect)frame midImg:(NSString*)img{
    if (self = [super initWithFrame:frame]) {
    
//        CircleConfigure *configure = [[CircleConfigure alloc]init];

        if (!_circleSlider) {
            _circleSlider = [[LFSCircleSlider alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-240)*0.5, 80, 240, 240)];
            _circleSlider.minimumTrackTintColor = XTAY_RGB(133, 37, 183);
            _circleSlider.maximumTrackTintColor = XTAY_RGB(247, 237, 244);
            _circleSlider.backgroundTintColor = XTAY_RGB(247, 237, 244);
            _circleSlider.circleBorderWidth = 30.0f;
            _circleSlider.circleRadius = 200 / 2.0 + 2;
            _circleSlider.value = 0;
            _circleSlider.loadProgress = 1;
            _circleSlider.startIcon = @"alarm";
            _circleSlider.endIcon = @"alarm";
        
        }
        [self addSubview:self.circleSlider];
        
        self.midImg = [[UIImageView alloc]init];
        NSString *imgStr = @"Airins";
        self.midImg.image = [UIImage imageNamed:imgStr];
        self.midImg.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.midImg];
        [self.midImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.circleSlider);
            make.size.mas_equalTo(CGSizeMake(100, 140));
        }];
    }
    return self;
}

@end
