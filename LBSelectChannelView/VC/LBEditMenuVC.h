//
//  LBEditMenuVC.h
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LBEditMenuDelegate <NSObject>

/**
 * tagsArr 排序后的选择数组
 * otherArr 排序后未选择数组
 */
- (void)editMenuTagsArr:(NSMutableArray *)tagsArr OtherArr:(NSMutableArray *)otherArr;

/**
 * 点击的标题
 * 对应的index
 */
- (void)editMenuDidSelectTitle:(NSString *)title Index:(NSInteger)index;

/**
 * 删除某个标题
 * 对应的index
 */
- (void)deleteTagWithTitle:(NSString *)title andIndex:(NSInteger)index;

/**
 * 添加标题
 * 对应的index
 */
- (void)addTagWithTitle:(NSString *)title andIndex:(NSInteger)index;


@end

@interface LBEditMenuVC : UIViewController

/**
 * 初始化方法
 */
- (instancetype)initWithSelectTagArray:(NSMutableArray *)selectArray andOtherArray:(NSMutableArray *)otherArray andSelectIndex:(NSInteger)selectIndex;

/** 代理 */
@property (nonatomic, weak) id <LBEditMenuDelegate>delegate;

/** 回退提醒 */
/**  selectIndex  是否删除了 刚进来选中的那和tag */
@property (nonatomic, copy) void(^goBack)(NSInteger selectIndex);

@end

