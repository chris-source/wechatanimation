//
//  DeviceView.m
//  微信下拉动画
//
//  Created by Chris on 2019/10/13.
//  Copyright © 2019年 Chris. All rights reserved.
//

#import "DeviceView.h"

#define KScreenWith     [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height


@interface DeviceView()<UIScrollViewDelegate>
{
    BOOL bShowSecondFloor;
    UIView *deviceViewPoint;
}


@property (nonatomic, assign) BOOL                      isShowFunctionalUnit;

@end

@implementation DeviceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.showsVerticalScrollIndicator   = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor                = UIColor.clearColor;

        NSLog(@"KZHSpaceViewHeight : %f",KZHSpaceViewHeight);
        NSLog(@"KZHShowMenuOffset : %f",KZHShowMenuOffset);
        [self setupSubViews];

    }
    return self;

    
}


- (void)layoutSubviews
{
    NSLog(@"\r\n===layoutSubviews begin ====\r\n contentInset:%@ \r\n contentOffset: %@ \r\n===layoutSubviews end ====\r\n",NSStringFromUIEdgeInsets(self.contentInset),NSStringFromCGPoint(self.contentOffset));
}


- (void)setupSubViews
{
    CGFloat contentHeight = KZHSpaceViewHeight;
    
    UIView *_spaceView = [[UIView alloc] init];
    _spaceView.backgroundColor = UIColor.clearColor;
    _spaceView.frame           = CGRectMake(0,0, KScreenWith, contentHeight);
    [self addSubview:_spaceView];

    CGFloat deviceViewContentHeight = 1000;
    //替换为真实的 deviceview，处理逻辑和现有的一样，高度调整为 KZHSpaceViewHeight（KScreenHeight - KZHNavBarHeight）
    UIView *deviceView = [[UIView alloc] initWithFrame:CGRectMake(0, contentHeight, KScreenWith, deviceViewContentHeight)];
    deviceView.backgroundColor = UIColor.redColor;
    [self addSubview:deviceView];
    
    self->deviceViewPoint = deviceView;
    
    self.contentSize  = CGSizeMake(KScreenWith, contentHeight + deviceViewContentHeight);
    self.contentInset = UIEdgeInsetsMake(-(contentHeight - KZHHeaderSceneHeight), 0, 0, 0);
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView.contentOffset.y < KZHBottomNavHeight && bShowSecondFloor) {
        [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [scrollView setContentOffset:CGPointMake(0, KZHBottomNavHeight)];
    }
    
    CGFloat begin_origin  = KZHSpaceViewHeight - KZHHeaderSceneHeight;
    CGFloat now_offsetY = scrollView.contentOffset.y;
    
    CGFloat difValue = begin_origin - now_offsetY;
    if (self.offSetChangeDelegate && difValue > 0) {
        if ([self.offSetChangeDelegate respondsToSelector:@selector(updateMarkView:)]) {
            [self.offSetChangeDelegate updateMarkView:difValue];
        }
    }

    
}

- (void)scrollViewWillEndDragging:(UIScrollView*)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint*)targetContentOffset
{
    CGFloat offsetY = scrollView.contentOffset.y;

    //处理 顶部区域的滑动交互处理，根据设计做调整
    if (offsetY > ((KZHSpaceViewHeight - KZHHeaderSceneHeight + 30))) {
        [scrollView setContentOffset:CGPointMake(0, KZHSpaceViewHeight) animated:YES];
        return;
    }
    //处理 顶部区域的滑动交互处理，根据设计做调整
    if (offsetY > ((KZHSpaceViewHeight - KZHHeaderSceneHeight)) && offsetY <= ((KZHSpaceViewHeight - KZHHeaderSceneHeight + 30))) {
        [scrollView setContentOffset:CGPointMake(0,(KZHSpaceViewHeight - KZHHeaderSceneHeight)) animated:YES];
        return;
    }
    
    //和现有的处理方案一致
    typeof(self) __weak weakSelf = self;
    CGFloat contentHeight = KZHSpaceViewHeight - KZHHeaderSceneHeight;

    if (self.isShowFunctionalUnit) {
        
        // 现在是显示
        if (offsetY > KZHHiddenMenuOffset) {
            [UIView animateWithDuration:0.2 animations:^{
                weakSelf.contentInset = UIEdgeInsetsMake(-(contentHeight), 0, 0, 0);
                weakSelf.isShowFunctionalUnit = NO;
            } completion:^(BOOL finished) {
                
            }];
            bShowSecondFloor = NO;
            if (self.offSetChangeDelegate && [self.offSetChangeDelegate respondsToSelector:@selector(updateMarkView:)]) {
                    [self.offSetChangeDelegate updateMarkView:0];
            }

        } else {
            if (offsetY <= KZHBottomNavHeight) {
                return;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf setContentOffset:CGPointMake(0,contentHeight) animated:YES];
                weakSelf.isShowFunctionalUnit = NO;
            });
            bShowSecondFloor = NO;
            if (self.offSetChangeDelegate && [self.offSetChangeDelegate respondsToSelector:@selector(updateMarkView:)]) {
                [self.offSetChangeDelegate updateMarkView:0];
            }

        }


    }else{
        
        if (offsetY <= KZHShowMenuOffset) {
            [UIView animateWithDuration:0.2 animations:^{
                self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            } completion:^(BOOL finished) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [weakSelf setContentOffset:CGPointMake(0,KZHBottomNavHeight) animated:YES];
                    weakSelf.isShowFunctionalUnit = YES;
                    [weakSelf showSecondFloor];

                });
                
            }];
            
        }
    }
    
    
}

- (void)showSecondFloor{
    bShowSecondFloor = YES;

}


#pragma - mark hit touch
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    CGPoint point2 = [self convertPoint:point toView:self->deviceViewPoint];
    
    if (!bShowSecondFloor) {
        return [super hitTest:point withEvent:event];
    }
    
    if (bShowSecondFloor && point2.y > 0) {
        return [super hitTest:point withEvent:event];
    }
    return nil;
}


@end
