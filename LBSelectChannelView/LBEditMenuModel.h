//
//  LBEditMenuModel.h
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBEditMenuModel : NSObject
/** title */
@property (nonatomic, copy) NSString *title;
/** 是否选中 */
@property (nonatomic, assign) BOOL selected;
/** 是否允许删除 */
@property (nonatomic, assign) BOOL resident;
/** 是否显示加号 */
@property (nonatomic, assign) BOOL showAdd;
/** 是否首选 */
@property (nonatomic, assign) BOOL isFirst; 
@end
