//
//  WaterFlowViewController.m
//  WaterFallsFlow
//
//  Created by caoyong on 2018/9/20.
//  Copyright © 2018年 caoyong. All rights reserved.
//

#import "WaterFlowViewController.h"
#import "WaterLayoutView.h"

@interface WaterFlowViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WaterLayoutViewDelegate>

/** 流式布局控件*/
@property(weak,nonatomic)UICollectionView * waterFlowCollectionView;

@end

@implementation WaterFlowViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self waterFlowCollectionView];
}

#pragma mark---lazy method
-(UICollectionView*)waterFlowCollectionView{
    
    if (!_waterFlowCollectionView) {
        WaterLayoutView * layoutView = [[WaterLayoutView alloc]initWithWaterLayoutView:self];
        UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layoutView];
        collectionView.backgroundColor = [UIColor whiteColor];
        _waterFlowCollectionView = collectionView;
        collectionView.dataSource = self;
    
        [self.view addSubview:collectionView];

        //注册
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _waterFlowCollectionView;
}


#pragma mark---UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1.f;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 50.f;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //creat cell...
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    
    return cell;
}

-(CGFloat)waterLayoutView:(WaterLayoutView *)waterLayoutView hegihtForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    //arc4random_uniform 随机的0到100之间的数 不包含100
    return 50 + arc4random_uniform(100);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end




