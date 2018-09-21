//
//  WaterLayoutView.h
//  WaterFallsFlow
//
//  Created by caoyong on 2018/9/20.
//  Copyright © 2018年 caoyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterLayoutView;
@protocol WaterLayoutViewDelegate <NSObject>

@required
/**
 * @param waterLayoutView 主对象
 *
 * @param index  indexpath item
 *
 * @param itemWidth item width
 *
 * return cell item height
 */
-(CGFloat)waterLayoutView:(WaterLayoutView*)waterLayoutView hegihtForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
/**
 * @param waterLayoutView 主对象
 *
 * return colunm count
 */
-(CGFloat)colunmCountWaterLayoutView:(WaterLayoutView*)waterLayoutView;
/**
 * @param waterLayoutView 主对象
 *
 * return colunm margin
 */
-(CGFloat)colunmMarginWaterLayoutView:(WaterLayoutView*)waterLayoutView;
/**
 * @param waterLayoutView 主对象
 *
 * return row margin
 */
-(CGFloat)rowMarginWaterLayoutView:(WaterLayoutView*)waterLayoutView;
/**
 * @param waterLayoutView 主对象
 *
 * return top、left、right、bottom margin
 */
-(UIEdgeInsets)edgeinsetsWaterLayoutView:(WaterLayoutView*)waterLayoutView;

@end

/**
 * 流式布局
 */
@interface WaterLayoutView : UICollectionViewLayout
/**
 * 初始化方法
 */
-(instancetype)initWithWaterLayoutView:(id<WaterLayoutViewDelegate>)waterFlowDelegate;

@end
