//
//  WaterFlowLayout.h
//  WaterfallFlow
//
//  Created by fangjs on 16/4/27.
//  Copyright © 2016年 fangjs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterFlowLayout;

@protocol WaterFlowLayoutDelegate <NSObject>
@required
/**
 *  返回 item 高度
 *  @param index           哪一个 item
 *  @param itemWidth       item 的宽度
 *  @return item 的高度
 */
- (CGFloat) waterFlowLayout:(WaterFlowLayout *)waterFlowLayout heightForItemAtIndex:(NSInteger )index itemWidth:(CGFloat) itemWidth;

@optional
/**
 *  返回多少列
 */
- (CGFloat)columnCountInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout;

/**
 *  返回行间距
 */
- (CGFloat)columnMarginInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout;

/**
 * 返回列间距
 */
- (CGFloat)rowMarginInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout;

/**
 *  返回边缘间距
 */
- (UIEdgeInsets)edgeInsetsInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout;
@end



@interface WaterFlowLayout : UICollectionViewLayout

@property (weak , nonatomic) id<WaterFlowLayoutDelegate> delegate;

@end
