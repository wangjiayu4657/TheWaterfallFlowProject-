//
//  WaterFlowLayout.m
//  WaterfallFlow
//
//  Created by fangjs on 16/4/27.
//  Copyright © 2016年 fangjs. All rights reserved.
//

#import "WaterFlowLayout.h"

/**默认的列数*/
static const NSInteger DefaultColumnCount = 3;
/** 每一列之间的距离*/
static const CGFloat DefaultColumnMargin = 10;
/**每一行之间的距离*/
static const CGFloat DefaultRowMargin = 10;
/**边缘间距*/
static const UIEdgeInsets DefaultEdgeInsets = {10,10,10,10};

@interface WaterFlowLayout ()
/**存放所有 cell 的布局属性*/
@property (strong , nonatomic) NSMutableArray *attrsArray;
/**存放所有列的当前高度*/
@property (strong , nonatomic) NSMutableArray *cellHeights;

@end


@implementation WaterFlowLayout


-(NSMutableArray *)attrsArray {
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

-(NSMutableArray *)cellHeights {
    if (!_cellHeights) {
        _cellHeights = [NSMutableArray array];
    }
    return _cellHeights;
}

/**
 *  初始化
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    [self.cellHeights removeAllObjects];
    for (NSInteger i = 0; i < DefaultColumnCount; i++) {
        [self.cellHeights addObject:@(DefaultEdgeInsets.top)];
    }
    
    /**清除原来的数据*/
    [self.attrsArray removeAllObjects];
    
    /**获取 cell 的总数*/
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        /**创建位置*/
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/**
 *  决定 cell 的排布
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

/**
 *  返回 indexPath位置 cell 对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    /**开始创建每一个 cell 对应的布局属*/
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionW = self.collectionView.frame.size.width;
   
    CGFloat w = (collectionW - DefaultEdgeInsets.left - DefaultEdgeInsets.right - (DefaultColumnCount - 1) * DefaultColumnMargin)/DefaultColumnCount;
    CGFloat h = 50 + arc4random_uniform(100);
    
    /**找出最短那一列*/
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.cellHeights[0] doubleValue];
    for (NSInteger i = 1; i < DefaultColumnCount; i++) {
        CGFloat columnHeight = [self.cellHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = DefaultEdgeInsets.left + destColumn *(w + DefaultColumnMargin);
    CGFloat y = minColumnHeight;
    if (y != DefaultEdgeInsets.top) {
        y += DefaultRowMargin;
    }
    
    attrs.frame = CGRectMake(x,y,w,h);
    /**更新最短那列的高度*/
    self.cellHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));

    return attrs;
}

/**
 *  决定 cell 的大小
 *  @return cell 的尺寸
 */
-(CGSize)collectionViewContentSize {
    
    //找出最短那一列
    NSInteger destColumn = 0;
    CGFloat maxColumnHeight = [self.cellHeights[0] doubleValue];
    for (NSInteger i = 1; i < DefaultColumnCount; i++) {
        CGFloat columnHeight = [self.cellHeights[i] doubleValue];
        if (maxColumnHeight < columnHeight) {
            maxColumnHeight = columnHeight;
            destColumn = i;
        }
    }

    return CGSizeMake(0, maxColumnHeight + DefaultEdgeInsets.bottom);
}

@end
