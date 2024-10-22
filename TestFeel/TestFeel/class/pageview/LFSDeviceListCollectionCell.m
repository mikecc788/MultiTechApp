//
//  LFSDeviceListCollectionCell.m
//  FeelLife
//
//  Created by app on 2022/10/22.
//

#import "LFSDeviceListCollectionCell.h"
#define RGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1]
@interface LFSDeviceListCollectionCell()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *lableView;
@property (strong , nonatomic)UILabel *titleLabel;
@property (strong , nonatomic)UIImageView *deviceImg;
@end

@implementation LFSDeviceListCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    if (!_bgView) {
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = RGB(242, 242, 251);
        self.bgView.layer.cornerRadius = 10;
        self.bgView.layer.masksToBounds = YES;
        [self addSubview:self.bgView];
    }
    NSLog(@"bgView=%@ titleL=%@",self.bgView,self.titleLabel.text);
    
    if (!self.lableView) {
        self.lableView = [[UIView alloc]init];
        self.lableView.backgroundColor = RGB(109, 81, 145);
        self.lableView.layer.cornerRadius = 5;
        self.lableView.layer.masksToBounds = YES;
        [self addSubview:self.lableView];
    }
   
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:22];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"AAAAA";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.lableView addSubview:_titleLabel];
    }
   
    if (!_deviceImg) {
        _deviceImg = [[UIImageView alloc] init];
        _deviceImg.image = [UIImage imageNamed:@"icon2"];
        _deviceImg.contentMode = UIViewContentModeScaleAspectFit;
        [self.bgView addSubview:_deviceImg];
    }
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(180);
    }];
    [self.lableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.mas_equalTo(50);
    }];
    [_deviceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.lableView);
        make.width.mas_equalTo(self.lableView).multipliedBy(0.9);
      
    }];
}
- (void)layoutSubviews
{
    [super layoutSubviews];

}
-(void)setTitle:(NSString *)title img:(NSString *)imgName{
    
    self.titleLabel.text = title;
    self.deviceImg.image = [UIImage imageNamed:@"icon2"];

}
@end
