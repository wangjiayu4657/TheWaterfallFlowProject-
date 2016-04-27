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

- (NSInteger) columnCount ;
- (NSInteger) columnMargin ;
- (NSInteger) rowMargin ;
- (UIEdgeInsets) edgeInsets;

@end


@implementation WaterFlowLayout


- (NSInteger) columnCount {
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterFlowLayout:)]) {
        return [self.delegate columnCountInWaterFlowLayout:self];
    }
    else {
        return DefaultColumnCount;
    }
}

- (NSInteger) columnMargin {
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterFlowLayout:)]) {
        return [self.delegate columnMarginInWaterFlowLayout:self];
    }
    else {
        return DefaultColumnMargin;
    }
}

- (NSInteger) rowMargin {
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterFlowLayout:)]) {
        return [self.delegate rowMarginInWaterFlowLayout:self];
    }
    else {
        return DefaultRowMargin;
    }
}

- (UIEdgeInsets) edgeInsets {
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterFlowLayout:)]) {
        return [self.delegate edgeInsetsInWaterFlowLayout:self];
    }
    else {
        return DefaultEdgeInsets;
    }
}

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
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.cellHeights addObject:@(self.edgeInsets.top)];
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
   
    CGFloat w = (collectionW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin)/self.columnCount;
    CGFloat h = [self.delegate waterFlowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    /**找出最短那一列*/
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.cellHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.cellHeights[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn *(w + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
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
    
    /**找出最短那一列*/
    NSInteger destColumn = 0;
    CGFloat maxColumnHeight = [self.cellHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.cellHeights[i] doubleValue];
        if (maxColumnHeight < columnHeight) {
            maxColumnHeight = columnHeight;
            destColumn = i;
        }
    }

    return CGSizeMake(0, maxColumnHeight + self.edgeInsets.bottom);
}

@end
