//
//  LBSelectChannelMacro.h
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#ifndef LBSelectChannelMacro_h
#define LBSelectChannelMacro_h

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)

//rgb色值
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define bgColor UIColorFromRGB(0xf5f5f5) //背景色
#define KPlaceHolderColor UIColorFromRGB(0xCCCCCC)//提示颜色
#define kComonColor UIColorFromRGB(0x333333)//灰黑色
#define KLineViewColor UIColorFromRGB(0xe8e8e8)  //分割线
#define KContentColor   UIColorFromRGB(0x666666) //内容颜色

#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) || ([(_ref) isKindOfClass:[NSNull class]]) )

#define isValidStr(_ref) ((IsNilOrNull(_ref)==NO) && ([(_ref) isKindOfClass:[NSString class]]) && ([_ref length]>0))

#define clearNilStr(str) (isValidStr(str)?str:@"")

#define clearNilReturnNull(str) (isValidStr(str)?str:[NSNull null])


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#endif /* LBSelectChannelMacro_h */
