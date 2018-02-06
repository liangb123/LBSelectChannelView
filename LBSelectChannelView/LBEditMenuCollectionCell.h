//
//  LBEditMenuCollectionCell.h
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBEditMenuModel.h"
@interface LBEditMenuCollectionCell : UICollectionViewCell
/** title */
@property (nonatomic, strong) UILabel *title;
/** closeBtn */
@property (nonatomic, strong) UIButton *closeBtn;
/** 数据模型 */
@property (nonatomic, strong) LBEditMenuModel *model;
/** cell样式 */
@property (nonatomic, strong) NSString *cellStyle;

@end
