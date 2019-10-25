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


#define GKPAGE_SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define GKPAGE_SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height



@interface ViewController ()<DeviceViewDelegate>
    
@property (nonatomic, strong) UIView *markView;
    
@property (nonatomic, strong) UILabel *progressLabel;
    
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
    
    
    UIView *markProgressView = [[UIView alloc] init];
    markProgressView.backgroundColor = UIColor.redColor;
    [_markView addSubview:markProgressView];
    [markProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_markView);
        make.left.equalTo(_markView).offset(30);
        make.size.mas_equalTo(20);
    }];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"0%";
    self.progressLabel = label;
    [_markView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_markView);
        make.left.equalTo(markProgressView.mas_right).offset(35);
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
        
        self.progressLabel.text = [NSString stringWithFormat:@"%f",progress];
        
        
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
