//
//  PageViewController.m
//  TestFeel
//
//  Created by app on 2022/10/24.
//

#import "PageViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryListContainerView.h"
#import "PageOneViewController.h"
#import "PageCollectionView.h"
#define LineHeight 5
#define OriginX 0
#define TitleViewHeight 50
#define RGB(x,y,z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1]
#define Localized(a) NSLocalizedString(a,nil)
@interface PageViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property(nonatomic,strong)NSArray *arrTitles;
@property(nonatomic,strong)NSMutableArray  *arrVCs;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property(nonatomic,strong)NSArray *titleArr;
@property(nonatomic,strong)PageOneViewController *list;
@property(nonatomic,strong)PageCollectionView *list1;
@property(nonatomic,strong)NSMutableArray *atomArr;
@property(nonatomic,strong)NSMutableArray *spirometerArr;
@property(nonatomic,strong)NSMutableArray *breathingArr;
@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.atomArr = [[NSMutableArray alloc]init];
    self.breathingArr = [[NSMutableArray alloc]init];
    self.spirometerArr = [[NSMutableArray alloc]init];
    [self.atomArr addObjectsFromArray:@[@"11",@"111",@"1111",@"111111",@"1111111",@"111111111"]];
    [self.spirometerArr addObjectsFromArray:@[@"22",@"2222",@"22222",@"2222222",@"2222222",@"22222222"]];
    [self.breathingArr addObjectsFromArray:@[@"33",@"333",@"3333",@"333333",@"3333333",@"33333333"]];
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleArr = @[Localized(@"雾化器") , Localized(@"肺功能仪"), Localized(@"肺活量训练器")];
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(OriginX, SafeAreaTopHeight +20, SCREEN_WIDTH-OriginX*2, TitleViewHeight)];

//    self.categoryView.defaultSelectedIndex = 1;
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    self.categoryView.titles = self.titleArr;
    self.categoryView.cellSpacing = 0;
    self.categoryView.contentEdgeInsetLeft = 25;
    self.categoryView.contentEdgeInsetRight = 25;
//    self.categoryView.averageCellSpacingEnabled = NO;
    self.categoryView.titleSelectedColor = RGB(147, 98, 173);
    self.categoryView.titleColor = RGB(169, 146, 208);
//    self.categoryView.titleFont = [UIFont systemFontOfSize:24];
    self.categoryView.titleFont = [UIFont systemFontOfSize:22 weight:40];
  
    self.categoryView.titleColorGradientEnabled = YES;
    //添加指示器
//    [self addLine1];
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor redColor];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[lineView];
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
    self.listContainerView.frame = CGRectMake(0, SafeAreaTopHeight + 20+TitleViewHeight+10, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight - 20);
    [self.view addSubview:self.listContainerView];
    //关联到categoryView
    self.categoryView.listContainer = self.listContainerView;
}
/**
 刷新设备
 */
- (void)reloadData {
    //重载之后默认回到0，你也可以指定一个index
    self.categoryView.defaultSelectedIndex = 0;
    self.categoryView.titles = self.titleArr;
    [self.categoryView reloadData];
}
-(NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 3;
}
-(id)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    self.list = [[PageOneViewController alloc] init];
//    self.list1 = [[PageCollectionView alloc] init];
//    self.list1.collectionView.scrollEnabled = YES;
//    self.list1.userInteractionEnabled = YES;
//    if (index == 0) {
//        self.list.type = LFSProductType_Mesh;
//    }else if(index == 1){
//        self.list.type = LFSProductType_Spirometer;
//    }else{
//        self.list.type = LFSProductType_Breathing;
//    }
    NSLog(@"initListForIndex =%ld  %@",index,self.titleArr[index]);
    return self.list;
}
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"categoryView =%ld  %@",index,self.titleArr[index]);
    if (index == 0) {

        [self.list setDeviceType:LFSProductType_Mesh];
//        [self.list1 setDevice:self.atomArr type:LFSProductType_Mesh];
    }else if(index == 1){
//        self.list.type = LFSProductType_Spirometer;
        [self.list setDeviceType:LFSProductType_Spirometer];
    }else{
//        self.list.type = LFSProductType_Breathing;
//        [self.list1 setDevice:self.breathingArr type:LFSProductType_Breathing];
        [self.list setDeviceType:LFSProductType_Breathing];
    }
    

}

-(void)addLine2{
    
}

-(void)addLine1{
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(OriginX, SafeAreaTopHeight +20-LineHeight+TitleViewHeight, SCREEN_WIDTH-OriginX*2, LineHeight)];
    lineV.layer.cornerRadius = LineHeight *0.5;
    lineV.layer.masksToBounds = YES;
    self.categoryView.alpha = 0.9;
    lineV.backgroundColor = RGB(236, 235, 251);
    [self.view addSubview:lineV];
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = RGB(97, 26, 135);
    lineView.indicatorHeight = LineHeight;
//    lineView.indicatorCornerRadius = LineHeight*0.5;
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        lineV.x = OriginX+lineView.x;
        lineV.w = SCREEN_WIDTH-OriginX*2-lineView.x*2;

    });
    self.categoryView.indicators = @[lineView];
}
@end
