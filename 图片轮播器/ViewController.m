//
//  ViewController.m
//  图片轮播器
//
//  Created by froda on 15/5/31.
//  Copyright (c) 2015年 froda. All rights reserved.
//

#import "ViewController.h"
#define IMGCOUNT 3
@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.scrollview.pagingEnabled = YES;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.delegate = self;
    
    float imgviewW = self.scrollview.frame.size.width;
    float imgviewH = self.scrollview.frame.size.height;
    float imgviewY = 5;
    //设置scrollview的内容范围
    self.scrollview.contentSize = CGSizeMake(imgviewW * IMGCOUNT, imgviewH);
    //添加UIImageView到scrollview上
    for (int i = 0; i < IMGCOUNT; i++) {
        NSString *imgName = [NSString stringWithFormat:@"img%d",i];
        float imgviewX = i * imgviewW;
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(imgviewX, imgviewY, imgviewW, imgviewH)];
        imgview.image = [UIImage imageNamed:imgName];
        [self.scrollview addSubview:imgview];
    }
    [self addTimer];//开始计时
  
}
/**
 *  添加计时器
 */
- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(pageChange) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];//分时操作，避免卡死
}
/**
 *  移除计时器
 */
- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}
/**
 *  page控制器
 */
- (void)pageChange{
    long page = 0;
    if (self.page.currentPage == 2) {
        page = 0;
    }else{
        page = self.page.currentPage + 1.0;
    }
    CGFloat offsetX = page * self.scrollview.frame.size.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollview setContentOffset:offset animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollW = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + scrollW * 0.5)/scrollW;
    self.page.currentPage = page;
}
//正在拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //停止定时器，停止后就不能再次开启了
    [self removeTimer];
}
//完全停止的时候拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}
@end
