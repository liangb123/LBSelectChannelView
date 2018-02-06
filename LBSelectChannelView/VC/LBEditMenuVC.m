//
//  LBEditMenuVC.m
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import "LBEditMenuVC.h"
#import "LBEditMenuCollectionCell.h"
#import "LBEditMenuHeaderView.h"
#import "LBEditMenuFooterView.h"
#import "LBEditMenuModel.h"

#define CELLID @"CollectionViewCell"
#define HEADERID @"headerId"
#define FOOTERID @"footerId"

@interface LBEditMenuVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *otherArrM;
@property (nonatomic, weak  ) UICollectionView *collectionView;
@property (nonatomic, weak  ) LBEditMenuHeaderView *headerView;
@property (nonatomic, weak  ) LBEditMenuFooterView *footerView;
/** 长按手势 */
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic, copy  ) NSString *editBtnStr;
/** 记录刚进来时候 选择的index */
@property (nonatomic, assign) NSInteger oldSelectIndex;
@end

@implementation LBEditMenuVC

- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (NSMutableArray *)otherArrM {
    if (!_otherArrM) {
        _otherArrM = [NSMutableArray array];
    }
    return _otherArrM;
}


- (instancetype)initWithSelectTagArray:(NSMutableArray *)selectArray andOtherArray:(NSMutableArray *)otherArray andSelectIndex:(NSInteger)selectIndex{
    if (self = [super init]) {
        self.oldSelectIndex = selectIndex;
        self.editBtnStr = @"编辑";
        
        for (int i = 0; i < selectArray.count; i++) {
            LBEditMenuModel *model = [[LBEditMenuModel alloc] init];
            NSString *title =selectArray[i];
            model.title = title;
            if (i == self.oldSelectIndex) {
                model.isFirst = YES;
            }else{
                model.isFirst = NO;
            }
            model.showAdd = NO;
            model.selected = NO;
            if (i == 0 || i == 1) {
                model.resident = YES;
            }
            [self.selectArray addObject:model];
        }
        
        for (NSString *title in otherArray) {
            LBEditMenuModel *model = [[LBEditMenuModel alloc] init];
            model.title = title;
            model.showAdd = YES;
            model.selected = NO;
            [self.otherArrM addObject:model];
        }
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        //初始化UI
        [self initColumnMenuUI];
}

#pragma mark - 初始化UI
- (void)initColumnMenuUI {
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
    //视图布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //UICollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 20) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.layer.masksToBounds = YES;
    collectionView.layer.cornerRadius = 5.0f;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    
    //注册cell
    [self.collectionView registerClass:[LBEditMenuCollectionCell class] forCellWithReuseIdentifier:CELLID];
    [self.collectionView registerClass:[LBEditMenuHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HEADERID];
    [self.collectionView registerClass:[LBEditMenuFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FOOTERID];
    if (NLSystemVersionGreaterOrEqualThan(9.0)) {
        if (@available(iOS 9.0, *)) {
            //添加长按的手势
            self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
            self.longPress.minimumPressDuration = 0.5f;
            [self.collectionView addGestureRecognizer:self.longPress];
        }
    }
}

#pragma mark - 手势识别
//精选和最新不允许拖动
- (void)longPress:(UIGestureRecognizer *)longPress {
    if ([self.editBtnStr containsString:@"编辑"]) {
        self.editBtnStr = @"完成";
        for (int i = 0; i < self.selectArray.count; i++) {
            LBEditMenuModel *model = self.selectArray[i];
            if (i == 0) {
                model.selected = NO;
            }else if (i == 1){
                model.selected = NO;
            }else{
                model.selected = YES;
            }
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.collectionView reloadSections:indexSet];
    }
    
    //获取点击在collectionView的坐标
    CGPoint point=[longPress locationInView:self.collectionView];
    //从长按开始
    NSIndexPath *indexPath=[self.collectionView indexPathForItemAtPoint:point];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (indexPath.section == 0 && indexPath.item == 0) {
            return;
        }
        if (indexPath.section == 0 && indexPath.item == 1) {
            return;
        }
        [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        //长按手势状态改变
    } else if(longPress.state==UIGestureRecognizerStateChanged) {
        if (indexPath.section == 0 && indexPath.item == 0) {
            return;
        }
        if (indexPath.section == 0 && indexPath.item == 1) {
            return;
        }
        [self.collectionView updateInteractiveMovementTargetPosition:point];
        //长按手势结束
    } else if (longPress.state==UIGestureRecognizerStateEnded) {
        [self.collectionView endInteractiveMovement];
        //其他情况
    } else {
        [self.collectionView cancelInteractiveMovement];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.otherArrM) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.selectArray.count;
    } else {
        return self.otherArrM.count;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.item == 0 || indexPath.item == 1) {
            return NO;
        } else {
            return YES;
        }
    } else {
        return YES;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LBEditMenuCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[LBEditMenuCollectionCell class]]){
        LBEditMenuCollectionCell *curCell = (LBEditMenuCollectionCell *)cell;
        if (indexPath.section == 0) {
            LBEditMenuModel *model = [self.selectArray objectAtIndex:indexPath.item];
            curCell.model = model;
            [curCell.closeBtn setImage:[UIImage imageNamed:@"addMedicine_Delete"] forState:0];
            curCell.closeBtn.hidden = !model.selected;
            if (indexPath.item == 0 || indexPath.item == 1) { //前两个按钮样式区别
                if (model.isFirst) {
                    curCell.title.textColor = [UIColor greenColor];
                    self.oldSelectIndex = indexPath.item;
                }else {
                    curCell.title.textColor = [UIColor grayColor];
                }
            }else{
                if (model.isFirst) {
                    self.oldSelectIndex = indexPath.item;
                    curCell.title.textColor = [UIColor greenColor];
                }else {
                    curCell.title.textColor = kComonColor;
                }
            }
            
            curCell.cellStyle = @"firstSection";
        } else {
            curCell.model = self.otherArrM[indexPath.item];
            curCell.title.textColor = kComonColor;
            curCell.closeBtn.hidden = NO;
            [curCell.closeBtn setImage:[UIImage imageNamed:@"addMedicine_AddGroup"] forState:0];
            //关闭按钮点击事件
            curCell.closeBtn.tag = indexPath.item;
            //            [curCell.closeBtn addTarget:self action:@selector(colseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            curCell.cellStyle = @"secondSection";
        }
    }
}

//headerView footerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        LBEditMenuHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADERID forIndexPath:indexPath];
        if (indexPath.section == 0) {
            [headerView.editBtn setTitle:self.editBtnStr forState:UIControlStateNormal];
            headerView.editBtn.hidden = NO;
            [headerView.editBtn addTarget:self action:@selector(headViewEditBtnClick) forControlEvents:UIControlEventTouchUpInside];
            
            [headerView.closeBtn addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
        }
        self.headerView = headerView;
        return headerView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        LBEditMenuFooterView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FOOTERID forIndexPath:indexPath];
        self.footerView = footerView;
        if (self.otherArrM.count <= 0) {
            self.footerView.hidden = YES;
        } else {
            self.footerView.hidden = NO;
        }
        
        return footerView;
    }
    return nil;
}

#pragma mark - 头部编辑按钮点击事件
- (void)headViewEditBtnClick {
    if ([self.editBtnStr containsString:@"编辑"]) {
        self.editBtnStr = @"完成";
        [self.headerView.editBtn setTitle:@"完成" forState:UIControlStateNormal];
        
        for (int i = 0; i < self.selectArray.count; i++) {
            LBEditMenuModel *model = self.selectArray[i];
            if (i == 0 || i == 1) {
                model.selected = NO;
            } else {
                model.selected = YES;
            }
        }
    } else {
        self.editBtnStr = @"编辑";
        [self.headerView.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
        //        [self.collectionView removeGestureRecognizer:self.longPress];
        
        for (int i = 0; i < self.selectArray.count; i++) {
            LBEditMenuModel *model = self.selectArray[i];
            if (i == 0 || i == 1) {
                model.selected = NO;
            } else {
                model.selected = NO;
            }
        }
    }
    [self.collectionView reloadData];
}

//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

//头部视图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(ScreenWidth, 55);
    } else {
        return CGSizeMake(0, 0);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(ScreenWidth, 110);
    } else {
        return CGSizeMake(0, 0);
    }
}

//定义每一个cell的大小   除去行列间距的 上左下右
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake( (ScreenWidth - 36) / 3  , 40);
}

//只控制行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

//只控制列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LBEditMenuModel *model;
    if (indexPath.section == 0) {
        model = self.selectArray[indexPath.item];
        //判断是否是编辑状态
        if ([self.editBtnStr containsString:@"编辑"]) {
            //判断是否是头条,是就直接回调出去
            if ([self.delegate respondsToSelector:@selector(editMenuDidSelectTitle:Index:)]) {
                self.goBack?self.goBack(indexPath.item):nil;  //手动指定了具体位置
                [self.delegate editMenuDidSelectTitle:model.title Index:indexPath.item];
                WS(ws)
                [self updateChnanel:^{
                    [ws dismissViewControllerAnimated:YES completion:nil];
                }];
            }
            return;
        }
        //判断是否可以删除
        if (model.resident) {
            return;
        }
        model.selected = NO;
        model.showAdd = YES;
        
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        LBEditMenuCollectionCell *curCell =  (LBEditMenuCollectionCell *)cell;
        //关闭按钮点击事件
        curCell.cellStyle = @"secondSection";
        
        [self.selectArray removeObjectAtIndex:indexPath.item];
        [self.otherArrM insertObject:model atIndex:0];
        
        [self.collectionView performBatchUpdates:^ {
            NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:0 inSection:1];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];
        }];
        //删除一条 index
        if ([self.delegate respondsToSelector:@selector(deleteTagWithTitle:andIndex:)]) {
            [self.delegate deleteTagWithTitle:model.title andIndex:indexPath.item];
            self.oldSelectIndex = -1;
        }
        
    } else if (indexPath.section == 1) {
        LBEditMenuCollectionCell *cell = (LBEditMenuCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.cellStyle = @"firstSection";
        cell.closeBtn.hidden = YES;
        model  = self.otherArrM[indexPath.item];
        if ([self.editBtnStr containsString:@"编辑"]) {
            model.selected = NO;
        } else {
            model.selected = YES;
        }
        model.showAdd = NO;
        
        //关闭按钮点击事件
        [self.otherArrM removeObjectAtIndex:indexPath.item];
        [self.selectArray addObject:model];
        
        [collectionView performBatchUpdates:^ {
            NSIndexPath *targetIndexPage = [NSIndexPath indexPathForItem:self.selectArray.count-1 inSection:0];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPage];
            
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];
        }];
        
        //新增一条 index
        if ([self.delegate respondsToSelector:@selector(addTagWithTitle:andIndex:)]) {
            [self.delegate addTagWithTitle:model.title andIndex:self.selectArray.count-1];
        }
    }
    
    [self refreshDelBtnsTag];
    [self updateBlockArr];
}

//在移动结束的时候调用此代理方法
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    LBEditMenuModel *model;
    if (sourceIndexPath.section == 0) {
        model = [self.selectArray objectAtIndex:sourceIndexPath.item];
        [self.selectArray removeObjectAtIndex:sourceIndexPath.item];
        //删除一条 index
        if ([self.delegate respondsToSelector:@selector(deleteTagWithTitle:andIndex:)]) {
            [self.delegate deleteTagWithTitle:model.title andIndex:sourceIndexPath.item];
            self.oldSelectIndex = -1;
        }
        
    } else {
        model = self.otherArrM[sourceIndexPath.item];
        [self.otherArrM removeObjectAtIndex:sourceIndexPath.item];
    }
    
    if (destinationIndexPath.section == 0) {
        model.selected = YES;
        [self.collectionView performBatchUpdates:^ {
            [self.selectArray insertObject:model atIndex:destinationIndexPath.item];
        } completion:^(BOOL finished) {
            [self.collectionView reloadData];
        }];
        [self refreshDelBtnsTag];
        //增加一条 index
        if ([self.delegate respondsToSelector:@selector(addTagWithTitle:andIndex:)]) {
            [self.delegate addTagWithTitle:model.title andIndex:destinationIndexPath.item];
        }
        [self updateBlockArr];
        
    } else if (destinationIndexPath.section == 1) {
        model.selected = NO;
        [self.collectionView performBatchUpdates:^ {
            [self.otherArrM insertObject:model atIndex:destinationIndexPath.item];
        } completion:^(BOOL finished) {
            [collectionView reloadData];
        }];
        [self refreshDelBtnsTag];
        [self updateBlockArr];
    }
}

#pragma mark - 刷新tag
- (void)refreshDelBtnsTag {
    for (LBEditMenuCollectionCell *cell in self.collectionView.visibleCells) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        cell.closeBtn.tag = indexPath.item;
    }
}

#pragma mark - 更新block数组
- (void)updateBlockArr {
    NSMutableArray *tempTagsArrM = [NSMutableArray array];
    NSMutableArray *tempOtherArrM = [NSMutableArray array];
    for (LBEditMenuModel *model in self.selectArray) {
        NSString *newModel = model.title;
        [tempTagsArrM addObject:newModel];
    }
    for (LBEditMenuModel *model in self.otherArrM) {
        NSString *newModel = model.title;
        [tempOtherArrM addObject:newModel];
    }
    
    if ([self.delegate respondsToSelector:@selector(editMenuTagsArr:OtherArr:)]) {
        [self.delegate editMenuTagsArr:tempTagsArrM OtherArr:tempOtherArrM];
    }
    if (self.otherArrM.count <= 0) {
        self.footerView.hidden = YES;
    } else {
        self.footerView.hidden = NO;
    }
}

- (void)backToVc{
    
    if (self.oldSelectIndex == -1) {
        self.goBack?self.goBack(-1):nil;
    }else{
        self.goBack?self.goBack(self.oldSelectIndex):nil;
    }
    
    WS(ws)
    [self updateChnanel:^{
        [ws dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)updateChnanel:(void(^)(void))complete{
    
    NSMutableArray *dataArr = [NSMutableArray array];
    for (LBEditMenuModel *model in self.selectArray) {
        if (![model.title isEqualToString:@"精选"] && ![model.title isEqualToString:@"最新"] ) {
            [dataArr addObject:model.title];
        }
    }
//    NSDictionary *param = @{@"data":dataArr.count > 0?dataArr:@[]};
    complete?complete():nil;
}

@end


