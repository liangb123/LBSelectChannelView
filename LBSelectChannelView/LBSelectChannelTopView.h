//
//  LBSelectChannelTopView.h
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LBSelectChannelTopView;

@protocol TopBarDelegate <NSObject>

- (void)TopBarChangeSelectedItem:(LBSelectChannelTopView *)topbar selectedIndex:(NSInteger)index;

@end

@interface LBSelectChannelTopView : UIScrollView

@property (nonatomic,weak) id<TopBarDelegate> topBarDelegate;

- (void)addTitleBtn:(NSString *)title;

- (void)setSelectedItem:(NSInteger)index;

- (void)removeTitleBtn:(NSString *)title;

- (void)removeAllBtn;

//重新布局
- (void)resetLayout;

@end

