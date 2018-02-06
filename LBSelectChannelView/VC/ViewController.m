//
//  ViewController.m
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import "ViewController.h"
#import "LBEditMenuVC.h"
#import "LBSelectChannelTopView.h"
#import "LBSelectChannelTabbarView.h"
#import "LBSelectChannelContentView.h"

@interface ViewController ()<LBEditMenuDelegate,TabbarViewDelegate>
@property (nonatomic, strong) LBSelectChannelTabbarView * tabbarView;
@property (nonatomic, strong) NSMutableArray<NSString  *> *selectSubjectArray;  //只是title
@property (nonatomic, strong) NSMutableArray<NSString *> *otherSubjectArray;  //只是title
@property (nonatomic, strong) NSMutableArray *titleViewArray;
@property (nonatomic, assign) NSInteger selectIndex; //选中的下标

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectIndex = 0;
    self.navigationItem.title = @"选择频道";
    [self.view addSubview:self.tabbarView];
    [self initDefaultVC];
}

- (void)initDefaultVC{
    
    [self.titleViewArray  removeAllObjects];
    [self.selectSubjectArray removeAllObjects];
    
    LBSelectChannelContentView * vc1 = [[LBSelectChannelContentView alloc]initWithFrame:CGRectZero andType:contentTypeForHandpick];
    NSString *model1 = @"精选";
    vc1.title = model1;
    [self.selectSubjectArray addObject:model1];
    [self.titleViewArray addObject:vc1];
    /*
    初始化 {
            firstHere == YES
            select == -1
          }
     */
    [self.tabbarView setTabDataSource:self.titleViewArray withFirstHere:YES isDeleteSelect:-1];
    
    LBSelectChannelContentView * vc2 =  [[LBSelectChannelContentView alloc]initWithFrame:CGRectZero andType:contentTypeForNew];
    NSString *model2 = @"最新";
    vc2.title = model2;
    [self.selectSubjectArray addObject:model2];
    [self.titleViewArray addObject:vc2];
    
    [self getData];
}

- (void)getData{
    
    //根据数据生成添加的title
    NSMutableArray *selectData = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        NSString *title = [NSString stringWithFormat:@"选择的标题%ld",(long)i];
        [selectData addObject:title];
    }
    [self.selectSubjectArray addObjectsFromArray:selectData];
    for (NSString *dataStr in selectData) {
        LBSelectChannelContentView * vc1 = [[LBSelectChannelContentView alloc]initWithFrame:CGRectZero andType:contentTypeForOther];
        vc1.title = dataStr;
        [self.titleViewArray addObject:vc1];
    }
    

    
    //根据数据生成全部title
    NSMutableArray *otherData = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        NSString *title = [NSString stringWithFormat:@"待选择标题%ld",(long)i];
        [otherData addObject:title];
    }
    self.otherSubjectArray = otherData;
    /*
      继续添加数据{
          firstHere == NO
          select == -2 用里面的oldindex
     }
     */
    [self.tabbarView setTabDataSource:self.titleViewArray withFirstHere:NO isDeleteSelect:-2];
}

- (void)btnClick:(UIButton *)btn {
    //初始化数据
    LBEditMenuVC *menuVC = [[LBEditMenuVC alloc] initWithSelectTagArray:self.selectSubjectArray andOtherArray:self.otherSubjectArray andSelectIndex:self.selectIndex];
    menuVC.delegate = self;
    WS(ws)
    [menuVC setGoBack:^(NSInteger selectIndex){
        /*
         返回时 重新布局{
                firstHere == NO
                select == selectIndex  
         }
         */
        [ws.tabbarView setTabDataSource:self.titleViewArray withFirstHere:NO isDeleteSelect:selectIndex];
    }];
    menuVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:menuVC animated:YES completion:nil];
}

#pragma mark - JMColumnMenuDelegate
- (void)editMenuTagsArr:(NSMutableArray *)tagsArr OtherArr:(NSMutableArray *)otherArr {
    self.selectSubjectArray= tagsArr;
    self.otherSubjectArray = otherArr;
}

- (void)editMenuDidSelectTitle:(NSString *)title Index:(NSInteger)index {
    [self.tabbarView selectItemForIndex:index];
}

- (void)deleteTagWithTitle:(NSString *)title andIndex:(NSInteger)index{
    if (self.titleViewArray.count > index) {
        LBSelectChannelContentView  * vc = [self.titleViewArray objectAtIndex:index];
        if (vc.superview) {
            [vc removeFromSuperview];
        }
        [self.titleViewArray removeObjectAtIndex:index];
    }
}

- (void)addTagWithTitle:(NSString *)title andIndex:(NSInteger)index{
    
    LBSelectChannelContentView * vc = [[LBSelectChannelContentView alloc]initWithFrame:CGRectZero andType:contentTypeForOther];
    vc.title = title;
    if (vc.superview) {
        [vc removeFromSuperview];
    }
    [self.titleViewArray insertObject:vc atIndex:index];
}

- (void)tabbarViewSelectIndex:(NSInteger )index{
    self.selectIndex = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//懒加载
- (LBSelectChannelTabbarView *)tabbarView{
    if (!_tabbarView) {
        WS(ws)
        _tabbarView  = [[LBSelectChannelTabbarView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth,ScreenHeight - 64) andAddNewItemBlock:^(UIButton *sender){
            [ws btnClick:sender];
        }];
        _tabbarView.delegate =self;
    }
    return _tabbarView;
}

- (NSMutableArray <NSString  *>*)selectSubjectArray{
    if (!_selectSubjectArray) {
        _selectSubjectArray = [NSMutableArray array];
    }
    return _selectSubjectArray;
}

- (NSMutableArray *)titleViewArray{
    if (!_titleViewArray) {
        _titleViewArray = [NSMutableArray array];
    }
    return _titleViewArray;
}

- (NSMutableArray<NSString  *> *)otherSubjectArray{
    if (!_otherSubjectArray) {
        _otherSubjectArray = [NSMutableArray array];
    }
    return _otherSubjectArray;
}

@end

