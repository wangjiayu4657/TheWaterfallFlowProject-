//
//  ViewController.m
//  WaterfallFlow
//
//  Created by fangjs on 16/4/27.
//  Copyright © 2016年 fangjs. All rights reserved.
//

#import "ViewController.h"
#import "WaterFlowLayout.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XMGShopCell.h"
#import "XMGShop.h"



@interface ViewController ()<UICollectionViewDataSource,WaterFlowLayoutDelegate>
/**所有商品数据*/
@property (nonatomic , strong) NSMutableArray *shops;
@property (nonatomic , weak) UICollectionView *collectionView;
@end


static NSString * const ShopId = @"shop";

@implementation ViewController

/**懒加载*/
- (NSMutableArray *)shops {
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor magentaColor];
    
    [self setupLayout];
    [self setupRefresh];
}

/**设置头部刷新*/
- (void) setupRefresh {
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.footer.hidden = YES;
}

/**下拉刷新加载新物品*/
- (void) loadNewShops {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *array = [XMGShop objectArrayWithFilename:@"1.plist"];
        NSLog(@"%@",array);
        [self.shops removeAllObjects];
        [self.shops addObjectsFromArray:array];
        /**刷新数据*/
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    });
}

/**上拉刷新加载更多物品*/
- (void) loadMoreShops {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *array = [XMGShop objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:array];
        /**刷新数据*/
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
    });
}

/**初始化collectionView*/
- (void) setupLayout {
    WaterFlowLayout *flowLayout = [[WaterFlowLayout alloc] init];
    flowLayout.delegate = self;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMGShopCell class]) bundle:nil] forCellWithReuseIdentifier:ShopId];
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
}

#pragma mark - UIVollectionView DataSource
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionView.footer.hidden = self.shops.count == 0;
    return self.shops.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XMGShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopId forIndexPath:indexPath];
    cell.shop = self.shops[indexPath.item];
    return cell;
}


#pragma mark - WaterFlowLayoutDelegate
/**返回 item 的高度*/
-(CGFloat)waterFlowLayout:(WaterFlowLayout *)waterFlowLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth {
    XMGShop *shop = self.shops[index];
    /**按等比例计算得出的高度*/
    return itemWidth * shop.h / shop.w;
}
/**返回列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout {
    return 2;
}

/**返回列间距*/
- (CGFloat) columnMarginInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout {
    return 10;
}

/**返回行间距*/
- (CGFloat) rowMarginInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout {
    return 10;
}

/**返回边缘间距*/
- (UIEdgeInsets) edgeInsetsInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
