//
//  SecondFloorView.m
//  微信下拉动画
//
//  Created by Chris on 2019/10/13.
//  Copyright © 2019年 Chris. All rights reserved.
//

#import "SecondFloorView.h"
#import <Masonry.h>

@implementation SecondFloorView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"2楼按钮" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [self addSubview:btn];
    
     [btn addTarget:self action:@selector(btnC:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)btnC:(id)btn{
    NSLog(@"2楼 点击了~");
}

@end
