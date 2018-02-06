//
//  LBSelectChannelTopView.m
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import "LBSelectChannelTopView.h"
#define normalFont  [UIFont systemFontOfSize:15];
#define selectFont  [UIFont boldSystemFontOfSize:16];
static CGFloat const topBarItemMargin = 20; ///标题之间的间距
static CGFloat const topBarHeight = 40; //顶部标签条的高度

@interface LBSelectChannelTopView()
@property (nonatomic,strong) NSMutableArray *btnArray;
@property (nonatomic,strong) UIButton *selectedBtn;

@property (nonatomic,strong) UILabel *selectedLab;
@end

@implementation LBSelectChannelTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)removeTitleBtn:(NSString *)title{
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.titleLabel.text isEqualToString:title]){
            [self.btnArray removeObject:obj];
        }
    }];
}

- (void)removeAllBtn{
    [self.btnArray removeAllObjects];
    [self removeAllSubviews];
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

- (void)addTitleBtn:(NSString *)title {
    UILabel *btn = [[UILabel alloc] init];
    btn.textColor = KContentColor;
    btn.font = normalFont;
    btn.text = clearNilStr(title);
    [btn sizeToFit];
    btn.userInteractionEnabled = YES;
    UITapGestureRecognizer *sliderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemSelectedChange:)];
    
    [btn addGestureRecognizer:sliderTap];
    [self addSubview:btn];
    [self.btnArray addObject:btn];
}

- (void)itemSelectedChange:(UITapGestureRecognizer *)sender {
    UILabel *lable =  (UILabel *)sender.view;
    NSInteger index = [self.btnArray indexOfObject:lable];
    [self setSelectedItem:index];
    
    if ([self.topBarDelegate respondsToSelector:@selector(TopBarChangeSelectedItem:selectedIndex:)]) {
        [self.topBarDelegate TopBarChangeSelectedItem:self selectedIndex:index];
    }
}

- (void)setSelectedItem:(NSInteger)index {
    [self layoutSubviews];
    
    UILabel *btn = self.btnArray[index];
    [UIView animateWithDuration:0.25 animations:^{
        self.selectedLab.font = normalFont;
        self.selectedLab.textColor = KContentColor;
        btn.font = selectFont;
        btn.textColor = [UIColor greenColor];
        self.selectedLab = btn;
        
        // 计算偏移量
        CGFloat offsetX = btn.center.x - ScreenWidth * 0.5;
        if (offsetX < 0) offsetX = 0;
        // 获取最大滚动范围
        CGFloat maxOffsetX = self.contentSize.width - ScreenWidth;
        if (offsetX > maxOffsetX) offsetX = maxOffsetX;
        
        if (self.contentSize.width - topBarItemMargin > [UIScreen mainScreen].bounds.size.width) {
            // 滚动标题滚动条
            [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        }
    }];
}

- (NSMutableArray *)btnArray{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (void)resetLayout{
    CGFloat btnH = topBarHeight;
    CGFloat btnX = topBarItemMargin;
    //在最近添加一个空白
    for (int i = 0 ; i < self.btnArray.count + 1; i++) {
        UILabel *btn;
        if (i == self.btnArray.count) {
            btn = [[UILabel alloc]init];
        }else{
            btn = self.btnArray[i];
        }
        CGSize size12 = [self getSizeWithStr:btn.text Height:topBarHeight Font:16];
        btn.frame = CGRectMake(btnX, 0, size12.width + 5, btnH);
        btnX += btn.frame.size.width + topBarItemMargin;
    }
    
    self.contentSize = CGSizeMake(btnX, 0);
}

#pragma mark - 固定宽度和字体大小，获取label的frame
- (CGSize)getSizeWithStr:(NSString *) str Height:(float)height Font:(float)fontSize{
    NSDictionary * attribute = @{NSFontAttributeName :[UIFont systemFontOfSize:fontSize] };
    CGSize tempSize=[str boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:attribute
                                      context:nil].size;
    return tempSize;
}

@end


