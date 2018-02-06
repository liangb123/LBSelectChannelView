//
//  LBEditMenuCollectionCell.m
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import "LBEditMenuCollectionCell.h"
@interface LBEditMenuCollectionCell()

@end
@implementation LBEditMenuCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = bgColor;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 2.0f;
        self.contentView.layer.borderColor = KPlaceHolderColor.CGColor;
        self.contentView.layer.borderWidth = 0.0f;
        
        //关闭按钮
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeBtn setImage:[UIImage imageNamed:@"addMedicine_Delete"] forState:UIControlStateNormal];
        [self.closeBtn  setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:0];
        self.closeBtn.hidden = YES;
        [self.contentView addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(3);
            make.height.width.mas_equalTo(11);
        }];
        
        //标题
        self.title = [[UILabel alloc] initWithFrame:CGRectZero];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.backgroundColor = bgColor;
        [self.contentView addSubview:self.title];
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-5);
            make.left.mas_equalTo(self.closeBtn.mas_right);
        }];
        
    }
    return self;
}

- (void)setModel:(LBEditMenuModel *)model {
    _model = model;
    if (ScreenHeight > 666) { //6 及以上
        //标题文字处理
        if (model.title.length == 6) {
            self.title.font = [UIFont systemFontOfSize:14];
        } else if (model.title.length > 6) {
            self.title.font = [UIFont systemFontOfSize:12];
        }else{
            self.title.font = [UIFont systemFontOfSize:15];
        }
    }else{
        //标题文字处理
        if (model.title.length == 5) {
            self.title.font = [UIFont systemFontOfSize:13];
        } else if (model.title.length > 5) {
            self.title.font = [UIFont systemFontOfSize:10];
        }else{
            self.title.font = [UIFont systemFontOfSize:14];
        }
    }
    
    self.title.text = [NSString stringWithFormat:@"%@",model.title];
}

- (void)setCellStyle:(NSString *)cellStyle{
    _cellStyle = cellStyle;
    if ([cellStyle isEqualToString:@"firstSection"]) {
        self.contentView.backgroundColor = bgColor;
        self.contentView.layer.borderColor = bgColor.CGColor;
        self.contentView.layer.borderWidth = 0.0f;
        self.title.backgroundColor = bgColor;
        
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.borderColor = KPlaceHolderColor.CGColor;
        self.contentView.layer.borderWidth = 1.0f;
        self.title.backgroundColor = [UIColor whiteColor];
    }
}

@end

