//
//  GifViewController.m
//  TestFeel
//
//  Created by app on 2023/3/29.
//

#import "GifViewController.h"
#import "FLAnimatedImage.h"
#import "SDAnimatedImageView.h"
#import "UIImage+GIF.h"
#import "YYImage.h"

@interface GifViewController ()
@property (nonatomic,strong) FLAnimatedImageView *flImage;
@property (nonatomic, strong) UIImageView  *gifImageview;
@property (nonatomic,strong) YYAnimatedImageView *YYImageView;

@end

@implementation GifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *images = [self processingGIFPictures:@"肺部示意图3"];
    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = images[0];
    [self.view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(200, 400));
    }];
    
    UIButton *start = [[UIButton alloc]init];
    [start setTitle:@"START" forState:(UIControlStateNormal)];
    [start setBackgroundColor:[UIColor greenColor]];
    [start addTarget:self action:@selector(start) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:start];
    [start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    UIButton *stop = [[UIButton alloc]init];
    [stop setTitle:@"STOP" forState:(UIControlStateNormal)];
    [stop setBackgroundColor:[UIColor greenColor]];
    [stop addTarget:self action:@selector(stop) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:stop];
    [stop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-150);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    
   
    
}
-(void)stop{
//    [self.flImage stopAnimating];
    [self.flImage removeFromSuperview];
//    [self.gifImageview removeFromSuperview];
    
//    [self.YYImageView removeFromSuperview];
}
-(void)start{
    
//    self.YYImageView = [[YYAnimatedImageView alloc]init];
//    [self.view addSubview:self.YYImageView];
//
//    [self.YYImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//     }];
//
//     YYImage *yyimage = [YYImage imageNamed:@"肺部示意图3"];
//     [self.YYImageView setImage:yyimage];
    
    self.flImage = [FLAnimatedImageView new];
    [self.view addSubview:self.flImage];
    
    [self.flImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    NSData *localData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"肺部示意图3" ofType:@"gif"]];
    FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:localData];
//    animatedImage1.frameCacheSizeMax = 2;
    self.flImage.animatedImage = animatedImage1;
    
    
//    self.gifImageview = [[SDAnimatedImageView alloc]init];
//    [self.view addSubview:self.gifImageview];
//    [self.gifImageview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.view);
//    }];
//
//    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"肺部示意图-2"] ofType:@"gif"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    UIImage *image = [UIImage sd_imageWithGIFData:data];
//    [self.gifImageview setImage:image];
}
-(NSArray *)processingGIFPictures:(NSString *)name{
    //获取Gif文件
    NSURL *gifImageUrl = [[NSBundle mainBundle] URLForResource: name withExtension:@"gif"];
    //获取Gif图的原数据
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)gifImageUrl, NULL);
    //获取Gif图有多少帧
    size_t gifcount = CGImageSourceGetCount(gifSource);
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < gifcount; i++) {
        //由数据源gifSource生成一张CGImageRef类型的图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        [images addObject:image];
        CGImageRelease(imageRef);
    }
    //得到图片数组
    return images;
}
@end
