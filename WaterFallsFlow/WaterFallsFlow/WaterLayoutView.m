//
//  WaterLayoutView.m
//  WaterFallsFlow
//
//  Created by caoyong on 2018/9/20.
//  Copyright © 2018年 caoyong. All rights reserved.
//

#import "WaterLayoutView.h"

/** 设置默认的流式布局试图列数**/
static const CGFloat WaterLayoutColumnCount = 3;
/***设置默认的流式布局列宽度*/
static const CGFloat WaterLayoutColumnMargin = 10;
/**设置默认的流式布局行高度**/
static const CGFloat WaterLayoutRowMargin = 10;
/**设置默认的流式布局 top、left、right、bottom 间距**/
static const UIEdgeInsets WaterLayoutEdgeInset = {10, 10, 10, 10};

@interface WaterLayoutView ()

//代理 delegate
@property(weak,nonatomic)id<WaterLayoutViewDelegate> waterFlowDelegate;

/**列最大的CGRectMaxY Value**/
@property(strong,nonatomic)NSMutableArray<NSNumber*> * columnMaxYArray;

/**cell 布局属性**/
@property(strong,nonatomic)NSMutableArray<UICollectionViewLayoutAttributes*> * attributesArray;

/**列数**/
@property(assign,nonatomic)CGFloat waterFlowColunm;
/**行间距**/
@property(assign,nonatomic)CGFloat waterFlowRowMargin;
/**列间距**/
@property(assign,nonatomic)CGFloat waterFlowColunmMargin;
/**列边缘距离**/
@property(assign,nonatomic)UIEdgeInsets waterFlowEdgeInstes;

@end

@implementation WaterLayoutView

#pragma mark---instancetype method

-(instancetype)initWithWaterLayoutView:(id<WaterLayoutViewDelegate>)waterFlowDelegate
{
    self = [super init];
    
    if (nil != self){
        self.waterFlowDelegate = waterFlowDelegate;
    }
    return self;
}

#pragma mark---布局

-(void)prepareLayout
{
    [super prepareLayout];
    
    //重置每一列的最大MaxY值
    [self.columnMaxYArray removeAllObjects];
    //当列的高度数组为空时候则进行数据的默认数据的设置、则以第一行计算
    for (int i=0; i<self.waterFlowColunm; i++) {
        
         [self.columnMaxYArray addObject:@(self.waterFlowEdgeInstes.top)];
    }
    //遍历cell 添加cell的布局属性
    NSUInteger itemCount = [self.collectionView numberOfItemsInSection:0];
   //遍历获取每个item对象的属性
    for (NSUInteger i = 0; i < itemCount; i++) {
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        UICollectionViewLayoutAttributes * attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
         // 计算布局属性并将结果添加到布局属性数组中
        [self.attributesArray addObject:attributes];
    }
}

#pragma mark--- cell item 布局属性
-(NSArray<UICollectionViewLayoutAttributes*>*)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attributesArray;
}

#pragma mark---private method
//collectionView 可滚动的范围
-(CGSize)collectionViewContentSize
{
    //获取最长列的最大的MaxY值
    CGFloat maxColunmHeight = [[self.columnMaxYArray firstObject] doubleValue];
    
    for (NSUInteger i = 1; i < self.columnMaxYArray.count; i++)
    {
        CGFloat tempColunmHeight = [[self.columnMaxYArray objectAtIndex:i] doubleValue];
        
        if (tempColunmHeight > maxColunmHeight)
        {
            maxColunmHeight = tempColunmHeight;
        }
    }
    
    return CGSizeMake(0, maxColunmHeight + self.waterFlowEdgeInstes.bottom);
}

#pragma mark --- 返回indexPath item对应的属性布局

-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
   //CollectionView Width
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
   //item width
    CGFloat itemWidth = (collectionViewWidth - self.waterFlowEdgeInstes.left - self.waterFlowEdgeInstes.right - self.waterFlowColunmMargin * (self.waterFlowColunm -1))/self.waterFlowColunm;
    //item Height
    CGFloat itemHeight = [self.waterFlowDelegate waterLayoutView:self hegihtForItemAtIndex:indexPath.item itemWidth:itemWidth];
    //item 应该拼接到最小的列数
    NSInteger stitchColumn = 0;
    //高度最小的列数
    CGFloat minItemHeight = [[self.columnMaxYArray objectAtIndex:0] doubleValue];
    for (NSUInteger i =1; i < self.columnMaxYArray.count; i++) {
        CGFloat tempMinItemHeight = [[self.columnMaxYArray objectAtIndex:i] doubleValue];
        if (tempMinItemHeight < minItemHeight)
        {
            minItemHeight = tempMinItemHeight;
            stitchColumn = i;
        }
    }
    //获取item x
    CGFloat item_x = self.waterFlowEdgeInstes.left + stitchColumn * (itemWidth + self.waterFlowColunmMargin);
    //获取item y
    CGFloat item_y = minItemHeight;
    if (item_y != self.waterFlowEdgeInstes.top){
        item_y += self.waterFlowRowMargin;
    }
    //设置布局属性的frame
    attributes.frame = CGRectMake(item_x,item_y, itemWidth, itemHeight);
    //更新高度
    self.columnMaxYArray[stitchColumn] = @(CGRectGetMaxY(attributes.frame));

    return attributes;
}


#pragma mark---lazy method && Setter、Getter

-(CGFloat)waterFlowColunm
{
    if ([self.waterFlowDelegate respondsToSelector:@selector(colunmCountWaterLayoutView:)])
    {
        return  [self.waterFlowDelegate colunmCountWaterLayoutView:self];
    }
    
    return WaterLayoutColumnCount;
}

-(CGFloat)waterFlowColunmMargin
{
    if ([self.waterFlowDelegate respondsToSelector:@selector(colunmMarginWaterLayoutView:)])
    {
        return [self.waterFlowDelegate colunmMarginWaterLayoutView:self];
    }
    
    return WaterLayoutColumnMargin;
}

-(CGFloat)waterFlowRowMargin
{
    if ([self.waterFlowDelegate respondsToSelector:@selector(rowMarginWaterLayoutView:)])
    {
        return [self.waterFlowDelegate rowMarginWaterLayoutView:self];
    }

    return WaterLayoutRowMargin;
}

-(UIEdgeInsets)waterFlowEdgeInstes
{
    if ([self.waterFlowDelegate respondsToSelector: @selector(edgeinsetsWaterLayoutView:)])
    {
        return [self.waterFlowDelegate edgeinsetsWaterLayoutView:self];
    }
    
    return WaterLayoutEdgeInset;
}


-(nonnull NSMutableArray<NSNumber*>*)columnMaxYArray
{
    if (!_columnMaxYArray) {
        
        _columnMaxYArray = [NSMutableArray array];
    }
    return _columnMaxYArray;
}

-(nonnull NSMutableArray<UICollectionViewLayoutAttributes*>*)attributesArray
{
    if (!_attributesArray) {
       
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

@end



