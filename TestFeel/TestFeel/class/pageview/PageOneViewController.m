//
//  PageOneViewController.m
//  TestFeel
//
//  Created by app on 2022/10/25.
//

#import "PageOneViewController.h"
#import "MJRefresh/MJRefresh.h"
#import "LFSDeviceListCollectionCell.h"
#define ItemLeftWidth  20.0
@interface PageOneViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isDataLoaded;
@property (nonatomic, assign) BOOL isAlreadyLoaded;
@property(nonatomic,assign)LFSProductType type;
@end

@implementation PageOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [NSMutableArray array];
    
    self.type = LFSProductType_Mesh;
 
}
- (void)loadDataForFirst {
    //第一次才加载，后续触发的不处理
    if (!self.isDataLoaded) {
        [self headerRefresh];
        self.isDataLoaded = YES;
        self.isAlreadyLoaded = YES;
    }

}

-(void)setDeviceType:(LFSProductType)type{
    if (!self.isDataLoaded){
        NSLog(@"isRefreshing");
        self.type = type;
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.calendar = [NSCalendar currentCalendar];
//        dateFormatter.dateFormat = @"HH:mm:ss";
//        NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.dataSource removeAllObjects];
//            for (int i = 0; i < 20; i++) {
//                [self.dataSource addObject:[NSString stringWithFormat:@"%@改变数据:%d", dateString, i]];
//            }
//        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.collectionView reloadData];
        });
        
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSLog(@"%@:%@", NSStringFromSelector(_cmd), self.title);
}
- (void)headerRefresh {
    NSLog(@"type=%lu",(unsigned long)self.type);
    [self.collectionView.mj_header beginRefreshing];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.calendar = [NSCalendar currentCalendar];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.dataSource removeAllObjects];
        for (int i = 0; i < 20; i++) {
            [self.dataSource addObject:[NSString stringWithFormat:@"%@测试数据:%d", dateString, i]];
        }
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
    });
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    NSLog(@"11111");
    [self loadDataForFirst];
    

    NSLog(@"%@:%@", NSStringFromSelector(_cmd), self.title);
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LFSDeviceListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLFSDeviceListCollectionCellID forIndexPath:indexPath];

    [cell setTitle:self.dataSource[indexPath.item] img:@"icon2"];
    NSLog(@"cell=%@ type=%lu device=%@",cell,(unsigned long)self.type,self.dataSource[indexPath.item]);
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH -20*3)*0.5  , 250);
}
//设置行与行间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, ItemLeftWidth, 0, ItemLeftWidth);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}
#pragma mark - Y间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 30 ;
}
- (UIView *)listView {
    return self.view;
}
-(void)listDidDisappear{

    self.isDataLoaded = NO;
}
- (void)listDidAppear {
    if (self.collectionView.mj_header.isRefreshing) {
        UIActivityIndicatorView *activity = [self.collectionView.mj_header valueForKey:@"loadingView"];
        [activity startAnimating];
    }
    
//    [self.collectionView reloadData];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"y===%f",scrollView.x);
//}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT );
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:[LFSDeviceListCollectionCell class] forCellWithReuseIdentifier:kLFSDeviceListCollectionCellID];
        [self.view addSubview:_collectionView];
    }
   
    return _collectionView;
}
@end
