//
//  LBEditMenuFooterView.m
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import "LBEditMenuFooterView.h"

@interface LBEditMenuFooterView()

/** 标题 */
@property (nonatomic, strong) UILabel *title;
/** 描述 */
@property (nonatomic, strong) UILabel *detail;

@end

@implementation LBEditMenuFooterView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *whiteView = [[UIView alloc]init];
        [self addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
        }];
        
        
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.text = @"推荐";
        [self.title setContentHuggingPriority:1000 forAxis:0];
        [self.title setContentHuggingPriority:1000 forAxis:1];
        self.title.font = [UIFont boldSystemFontOfSize:18];
        self.title.textColor = [UIColor blackColor];
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(whiteView.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(self.mas_left).mas_offset(10);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-15);
        }];
        
        self.detail = [[UILabel alloc] initWithFrame:CGRectZero];
        self.detail.text = @"(点击添加至我的兴趣)";
        [self.detail setContentHuggingPriority:1000 forAxis:1];
        self.detail.textColor = [UIColor lightGrayColor];
        self.detail.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.detail];
        [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.title.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.title);
            make.right.mas_equalTo(self.mas_right).mas_offset(-14);
        }];
    }
    return self;
}

@end


