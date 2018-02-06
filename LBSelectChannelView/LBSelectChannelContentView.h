//
//  LBSelectChannelContentView.h
//  LBSelectChannelView
//
//  Created by 梁冰 on 2018/2/6.
//  Copyright © 2018年 梁冰. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , contentType){
    contentTypeForNew = 0,
    contentTypeForHandpick,   //精选
    contentTypeForOther,
};

@interface LBSelectChannelContentView : UIView
@property (nonatomic, strong) NSString *title;
- (instancetype)initWithFrame:(CGRect)frame andType:(contentType)type;
@end
