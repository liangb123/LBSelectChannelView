//
//  LBSelectChannelTabbarView.h
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TabbarViewDelegate <NSObject>

- (void)tabbarViewSelectIndex:(NSInteger )index;

@end

@interface LBSelectChannelTabbarView : UIView
@property (nonatomic, weak ) id<TabbarViewDelegate> delegate;
@property (nonatomic,strong) UIScrollView *contentView;

- (instancetype)initWithFrame:(CGRect)frame andAddNewItemBlock:(void(^)(UIButton *sender))addMore;

/**
 @param data 数据源
 @param isFirst 是否第一次
 @param selectIndex 是否删除了选定了某个频道 {
   selectIndex == -1，删除了我进去是选择的那个标签。跳转到第一个标签（精选）
   selectIndex == -2 选择已经存在的index 用oldIndex跳转。
   其他情况用, 用selectIndex作为下标进行跳转
 }
 */
- (void)setTabDataSource:(NSMutableArray *)data withFirstHere:(BOOL)isFirst isDeleteSelect:(NSInteger)selectIndex;

//选中某个item
- (void)selectItemForIndex:(NSInteger)index;


@end
