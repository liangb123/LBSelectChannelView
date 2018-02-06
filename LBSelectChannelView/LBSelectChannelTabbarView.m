//
//  LBSelectChannelTabbarView.m
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import "LBSelectChannelTabbarView.h"
#import "LBSelectChannelTopView.h"
#import "LBSelectChannelContentView.h"

static CGFloat const topBarHeight = 40; //顶部标签条的高度

@interface LBSelectChannelTabbarView () <UIScrollViewDelegate,TopBarDelegate>
@property (nonatomic, strong) NSMutableArray<LBSelectChannelContentView *> *subViewControllers;
@property (nonatomic, strong) LBSelectChannelTopView *tabbar;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, copy  ) void(^addMore)(UIButton *sender);
@property (nonatomic, assign) NSInteger oldIndex;

@end

@implementation LBSelectChannelTabbarView

- (instancetype)initWithFrame:(CGRect)frame andAddNewItemBlock:(void(^)(UIButton *sender))addMore{
    self = [super initWithFrame:frame];
    if (self) {
        self.addMore = addMore;
        [self setUpSubview];
    }
    return self;
}

//添加子控件
- (void)setUpSubview{
    
    self.tabbar = [[LBSelectChannelTopView alloc] init];
    [self addSubview:self.tabbar];
    [self.tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(topBarHeight);
    }];
    self.tabbar.topBarDelegate = self;
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tabbar.mas_bottom);
        make.left.right.bottom.mas_equalTo(self);
    }];
    
    [self addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right);
        make.width.height.mas_equalTo(topBarHeight);
        make.width.mas_equalTo(36);
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    lineView.backgroundColor = KLineViewColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.tabbar.mas_bottom);
    }];
    
}

#pragma mark - ************************* 代理方法 *************************
- (void)selectItemForIndex:(NSInteger)index{
    [self addTable:index];
    [self.tabbar setSelectedItem:index];
    [self.contentView setContentOffset:CGPointMake(ScreenWidth * index , 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    self.oldIndex = index;
    if ([self.delegate respondsToSelector:@selector(tabbarViewSelectIndex:)]) {
        [self.delegate tabbarViewSelectIndex:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
    [self addTable:index];
    [self.tabbar setSelectedItem:index];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        NSInteger index = (scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5) / scrollView.bounds.size.width;
        [self addTable:index];
        [self.tabbar setSelectedItem:index];
    }
    
}

//Delegate方法
- (void)TopBarChangeSelectedItem:(LBSelectChannelTopView *)topbar selectedIndex:(NSInteger)index {
    [self addTable:index];
    NSInteger currentIndex = self.contentView.contentOffset.x / ScreenWidth;
    if (labs(currentIndex - index) < 4) {
        [self.contentView setContentOffset:CGPointMake(ScreenWidth * index, 0) animated:YES];
    }else{
        [self.contentView setContentOffset:CGPointMake(ScreenWidth * index, 0) animated:NO];
    }
}

-(void)addTable:(NSInteger) index {
    LBSelectChannelContentView *view = [self.subViewControllers objectAtIndex:index];
    if (![self.contentView.subviews containsObject:view]) {
        [self.contentView addSubview:view];
    }
    [self bringSubviewToFront:view];
}

- (void)setTabDataSource:(NSMutableArray *)data withFirstHere:(BOOL)isFirst isDeleteSelect:(NSInteger)selectIndex{
    self.subViewControllers = data.mutableCopy;
    [self.tabbar removeAllBtn];
    WS(ws)
    [self.subViewControllers enumerateObjectsUsingBlock:^(LBSelectChannelContentView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [ws.tabbar addTitleBtn:obj.title];
        obj.frame = CGRectMake(idx *ScreenWidth, 0, ScreenWidth, ScreenHeight - topBarHeight - 64);
    }];
    [self.tabbar resetLayout];
    LBSelectChannelContentView *firstView = self.subViewControllers.firstObject;
    if (![self.contentView.subviews containsObject:firstView]) {
        [self.contentView addSubview:firstView];
    }
    
    self.contentView.contentSize = CGSizeMake(ScreenWidth * (self.subViewControllers.count), 0);
    if (isFirst) {
        [self.tabbar setSelectedItem:0];
    }else{
        if (selectIndex == -1) {
            [self.tabbar setSelectedItem:0];
            [self.contentView setContentOffset:CGPointMake(0 , 0) animated:YES];
        }else if(selectIndex == -2){
            [self.tabbar setSelectedItem:self.oldIndex];
            [self addTable:self.oldIndex];
            [self.contentView setContentOffset:CGPointMake(ScreenWidth * self.oldIndex , 0) animated:YES];
        }else{
            [self.tabbar setSelectedItem:selectIndex];
            [self addTable:selectIndex];
            [self.contentView setContentOffset:CGPointMake(ScreenWidth * selectIndex , 0) animated:YES];
        }
    }
}

- (void)addNewItem:(UIButton *)sender{
    self.addMore?self.addMore(sender):nil;
}

#pragma mark - ************************* 懒加载 *************************
- (NSMutableArray<LBSelectChannelContentView *> *)subViewControllers{
    
    if (!_subViewControllers) {
        _subViewControllers = [NSMutableArray array];
    }
    return _subViewControllers;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.scrollsToTop = NO;
        _contentView.delegate = self;
        _contentView.pagingEnabled = YES;
        _contentView.clipsToBounds = YES;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.bounces = NO;
    }
    return _contentView;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.alpha = 0.9;
        [_addBtn setImage:[UIImage imageNamed:@"addCaseChnanel"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addNewItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}
@end


