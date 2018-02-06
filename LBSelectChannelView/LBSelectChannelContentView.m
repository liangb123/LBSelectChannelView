//
//  LBSelectChannelContentView.m
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import "LBSelectChannelContentView.h"

@interface LBSelectChannelContentView ()<UIScrollViewDelegate>
@property (nonatomic, assign) contentType type;
@property (nonatomic, strong) UILabel *contentLab;

@end

@implementation LBSelectChannelContentView
#pragma mark ------------------------------load view  ------------------------------
- (instancetype)initWithFrame:(CGRect)frame andType:(contentType)type{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.type = type;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self getNetData];
}

- (void)setupUI {
    if ([self.subviews containsObject:self.contentLab]) {
        self.contentLab.text = self.title;
    } else {
        [self addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
        }];
        self.contentLab.text = self.title;
    }
}

#pragma mark ------------------------------ NetData ------------------------------
-(void)getNetData{
    
    if (self.type == contentTypeForNew) {
        NSLog(@"操作最新数据");
        
    }else if (self.type == contentTypeForHandpick){
        NSLog(@"操作精选数据");
        
    }else if (self.type == contentTypeForOther){
        NSLog(@"操作其他类型数据");
    }
    
    [self setupUI];
}

- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]init];
    }
    return _contentLab;
}

@end

