//
//  RefreshDeviceBaseVC.m
//  TestFeel
//
//  Created by app on 2022/10/28.
//

#import "RefreshDeviceBaseVC.h"
#import "MJRefresh/MJRefresh.h"
#import "LFSDeviceListCollectionCell.h"
#define ItemLeftWidth  20.0
@interface RefreshDeviceBaseVC ()
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isDataLoaded;
@end

@implementation RefreshDeviceBaseVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    [self.collectionView registerClass:[LFSDeviceListCollectionCell class] forCellWithReuseIdentifier:kLFSDeviceListCollectionCellID];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
}

- (void)headerRefresh {
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

- (void)loadDataForFirst {
    //第一次才加载，后续触发的不处理
    if (!self.isDataLoaded) {
        [self headerRefresh];
        self.isDataLoaded = YES;
    }
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LFSDeviceListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLFSDeviceListCollectionCellID forIndexPath:indexPath];
    [cell setTitle:self.dataSource[indexPath.item] img:@"icon2"];
    
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
#pragma mark <UICollectionViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.didScrollCallback ?: self.didScrollCallback(scrollView);
}

#pragma mark - dealloc
- (void)dealloc{
    self.didScrollCallback = nil;
}
@end
