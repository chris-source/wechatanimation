//
//  ViewController.m
//  微信下拉动画
//
//  Created by Chris on 2019/10/13.
//  Copyright © 2019年 Chris. All rights reserved.
//

#import "ViewController.h"
#import "SecondFloorView.h"
#import "DeviceView.h"
#import <Masonry.h>
#import "ZJCircleProgressView.h"




@interface ViewController ()<DeviceViewDelegate>
    
@property (nonatomic, strong) UIView *markView;
    
@property (nonatomic, strong) UILabel *progressLabel;
    
    
@property (nonatomic, strong) ZJCircleProgressView *progressView;
    
@end

@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColor.whiteColor;
    
    SecondFloorView *sec = [[SecondFloorView alloc] init];
    sec.backgroundColor = UIColor.grayColor;
    [self.view addSubview:sec];
    [sec mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.markView = [[UIView alloc] init];
    self.markView.backgroundColor = UIColor.clearColor;
    self.markView.alpha = 0.0f;
    [self.view addSubview:self.markView];
    [self.markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(KZHNavBarHeight + KZHHeaderSceneHeight - 20);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(@(GKPAGE_SCREEN_WIDTH));
    }];
    
    
    self.progressView = [[ZJCircleProgressView alloc] init];
    // 背景色
    self.progressView.trackBackgroundColor = [UIColor clearColor];
    // 进度颜色
    self.progressView.trackColor = [UIColor whiteColor];
    self.progressView.lineWidth = 4;
//    self.progressView.headerImage = [self drawImage];
    // 开始角度位置
    //    self.progressView.beginAngle =
    // 自定义progressLabel的属性...
//    self.progressView.progressLabel.textColor = [UIColor lightGrayColor];
    [self.progressView.progressLabel setHidden:YES];
    self.progressView.progress = 0.0;

    
//    UIView *markProgressView = [[UIView alloc] init];
//    markProgressView.backgroundColor = UIColor.redColor;
    [_markView addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_markView);
        make.left.equalTo(_markView).offset(45);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"下拉查看更多环境信息...";
    self.progressLabel = label;
    [_markView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_markView);
        make.left.equalTo(_progressView.mas_right).offset(35);
    }];
    
    
    DeviceView *dv = [[DeviceView alloc] init];
    [self.view addSubview:dv];
    dv.offSetChangeDelegate = self;
    [dv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@KZHNavBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}
    
    //可以采用 racobserver 观察属性 实现
- (void)updateMarkView:(CGFloat)scrollViewOffsetDifValue{
    NSLog(@"scrollViewOffsetDifValue: %f",scrollViewOffsetDifValue);
    
    if (scrollViewOffsetDifValue == 0) {
        self.markView.alpha = 0.0f;
        [self.markView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(50);
        }];
        
        return;
    }
    
    if (scrollViewOffsetDifValue > 0 && scrollViewOffsetDifValue <= 70) {
        CGFloat progress = scrollViewOffsetDifValue/70;
        CGFloat sizeValue = 50 * progress;
        CGFloat markViewSizeValue = 50 + sizeValue;
        
        CGFloat alphaValue = 1 * progress;
        self.markView.alpha = alphaValue;
        
        self.progressView.progress = progress;

        
        [self.markView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(markViewSizeValue);
        }];
    }
    
}
    
- (void)configMarkView:(BOOL)bHidden{
    self.markView.hidden = bHidden;
    
    if (bHidden) {
        self.markView.alpha = 0.0f;
    }else{
        self.markView.alpha = 1.0f;
    }
}
    
    @end
