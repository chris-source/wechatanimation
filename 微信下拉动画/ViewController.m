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

@interface ViewController ()<DeviceViewDelegate>

@property (nonatomic, strong) UIView *markView;

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
    self.markView.backgroundColor = UIColor.blueColor;
    self.markView.alpha = 0.0f;
    [self.view addSubview:self.markView];
    [self.markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(KZHNavBarHeight + KZHHeaderSceneHeight);
        make.size.mas_equalTo(50);
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
            make.size.mas_equalTo(50);
        }];

        return;
    }
    
    if (scrollViewOffsetDifValue > 0 && scrollViewOffsetDifValue <= 100) {
        CGFloat progress = scrollViewOffsetDifValue/100;
        CGFloat sizeValue = 50 * progress;
        CGFloat markViewSizeValue = 50 + sizeValue;
        
        CGFloat alphaValue = 1 * progress;
        self.markView.alpha = alphaValue;
        
        [self.markView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(markViewSizeValue);
        }];
    }
    
}

@end
