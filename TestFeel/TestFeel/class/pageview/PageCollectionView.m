//
//  PageCollectionView.m
//  TestFeel
//
//  Created by app on 2022/10/28.
//

#import "PageCollectionView.h"
#import "LFSDeviceListCollectionCell.h"
#define ItemLeftWidth  20.0
@interface PageCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSMutableArray *deviceArr;
@property(nonatomic,assign)LFSProductType type;
@end

@implementation PageCollectionView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.collectionView.backgroundColor = [UIColor whiteColor];
       
        self.deviceArr = [[NSMutableArray alloc]init];
        self.type = LFSProductType_Mesh;
        
    }
    return self;
}
-(void)setDevice:(NSMutableArray *)device type:(LFSProductType)type{
    [self.deviceArr removeAllObjects];

    [self.deviceArr addObjectsFromArray:device];
    self.type = type;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    
}
#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"numberOfItemsInSection=%@",self.deviceArr);
    return self.deviceArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LFSDeviceListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLFSDeviceListCollectionCellID forIndexPath:indexPath];

    [cell setTitle:@"112222" img:@"icon2"];
    NSLog(@"cell=%@ type=%lu device=%@",cell,(unsigned long)self.type,self.deviceArr);
    
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
-(UIView *)listView{
    return self;
}
-(void)listDidAppear{
    NSLog(@"device ======%@",self.deviceArr);
    [self.collectionView reloadData];
}
#pragma mark - LazyLoad
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
//        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -SafeAreaTopHeight - 50 -SafeAreaBottomHeight);
        _collectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT );
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:[LFSDeviceListCollectionCell class] forCellWithReuseIdentifier:kLFSDeviceListCollectionCellID];
        [self addSubview:_collectionView];
    }
   
    return _collectionView;
}
@end
