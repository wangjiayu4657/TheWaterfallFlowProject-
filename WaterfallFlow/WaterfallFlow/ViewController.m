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



@interface ViewController ()<UICollectionViewDataSource>
/**所有商品数据*/
@property (nonatomic , strong) NSMutableArray *shops;
@property (nonatomic , weak) UICollectionView *collectionView;
@end


static NSString * const ShopId = @"shop";

@implementation ViewController

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

- (void) setupRefresh {
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.footer.hidden = YES;
}

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

- (void) loadMoreShops {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *array = [XMGShop objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:array];
        /**刷新数据*/
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
    });
}

- (void) setupLayout {
    WaterFlowLayout *flowLayout = [[WaterFlowLayout alloc] init];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
