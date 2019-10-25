//
//  DeviceView.h
//  微信下拉动画
//
//  Created by Chris on 2019/10/13.
//  Copyright © 2019年 Chris. All rights reserved.
//

#import <UIKit/UIKit.h>


#define IS_IPhoneXSeries ({\
BOOL is_IphoneXseries = NO;\
if (@available(iOS 11.0, *)) {\
is_IphoneXseries = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0; \
}\
is_IphoneXseries; \
})\



#define KZHNavBarHeight              (IS_IPhoneXSeries ? 88.0f : 64.0f)
#define KZRXMoveHeight ((IS_IPhoneXSeries ? 34.f : 0.f))

#define KZHHeaderHeight                  197
#define KZHHeaderSceneHeight             100
//底部导航栏的高度
#define KZHBottomNavHeight          (66.f + KZRXMoveHeight)
#define KZHSpaceViewHeight          (KScreenHeight - KZHNavBarHeight)

#define ZJTabHeight  (KZRXMoveHeight + 60)

#define KZHHiddenMenuOffset 85

//下滑距离设置，超过时执行 下拉动画显示2楼内容区域
#define KZHShowMenuOffset (KZHSpaceViewHeight - KZHHeaderSceneHeight - 70)


NS_ASSUME_NONNULL_BEGIN

@protocol DeviceViewDelegate <NSObject>
    
- (void)updateMarkView:(CGFloat)scrollViewOffsetDifValue;
- (void)configMarkView:(BOOL)bHidden;
    
    @end


@interface DeviceView : UIScrollView
    
    @property (nonatomic, weak) id <DeviceViewDelegate> offSetChangeDelegate;
    
    @end

NS_ASSUME_NONNULL_END
