//
//  LBEditMenuHeaderView.m
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import "LBEditMenuHeaderView.h"
@interface LBEditMenuHeaderView()

/** 标题 */
@property (nonatomic, strong) UILabel *title;

@end
@implementation LBEditMenuHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.text = @"我的兴趣";
        self.title.font = [UIFont boldSystemFontOfSize:18];
        [self.title setContentHuggingPriority:1000 forAxis:0];
        self.title.textColor = [UIColor blackColor];
        [self addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(10);
            make.top.mas_equalTo(self.mas_top).mas_offset(18);
        }];
        
        self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.editBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        self.editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.editBtn.layer.masksToBounds = YES;
        self.editBtn.layer.cornerRadius = 3.f;
        self.editBtn.layer.borderColor = [UIColor greenColor].CGColor;
        self.editBtn.layer.borderWidth = 0.5f;
        self.editBtn.hidden = YES;
        [self addSubview:self.editBtn];
        [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.title.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.title);
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(20);
        }];
        
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeBtn setImage:[UIImage imageNamed:@"caseLibClose"] forState:0];
        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(-1);
            make.width.mas_equalTo(36);
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(self.title);
        }];
    }
    return self;
}

@end

