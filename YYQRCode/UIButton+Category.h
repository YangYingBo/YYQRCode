//
//  UIButton+Category.h
//  masonry链式编程
//
//  Created by Loser on 16/11/25.
//  Copyright © 2016年 Mac. All rights reserved.
//


typedef enum{
    LOSERButtonEdgeInsetsStyleTop, // image在上，label在下
    LOSERButtonEdgeInsetsStyleLeft, // image在左，label在右
    LOSERButtonEdgeInsetsStyleBottom, // image在下，label在上
    LOSERButtonEdgeInsetsStyleRight // image在右，label在左
}LOSERButtonEdgeInsetsStyle;



#import <UIKit/UIKit.h>

@interface UIButton (Category)
/**
 *  默认标题
 */
- (UIButton *(^)(NSString *title))buttonNormalTitle;
/**
 *  默认标题颜色
 */
- (UIButton *(^)(UIColor *norColor))buttonNormalColor;
/**
 *  选中标题
 */
- (UIButton *(^)(NSString *seleTitle))buttonSelecteTitle;
/**
 *  选中标题颜色
 */
- (UIButton *(^)(UIColor *SelecteColor))buttonSelecteColor;
/**
 *  默认图标
 */
- (UIButton *(^)(UIImage *normalImg))buttonNormalImg;
/**
 *  选中图标
 */
- (UIButton *(^)(UIImage *selecteImg))buttonSelecteImg;


/**
  高亮图标
 */
- (UIButton *(^)(UIImage *))buttonHighlighted;
/**
 *  frame
 */
- (UIButton *(^)(CGRect frame))buttonFrame;
/**
 *  标题字体大小
 */
- (UIButton *(^)(float fontSize))buttonSystemFont;
/**
 *  tag
 */
- (UIButton *(^)(NSUInteger tag))buttonTag;
/**
 *  添加点击事件
 */
- (UIButton *(^)(id target,SEL action,UIControlEvents ControlEvents))buttonAddClickAction;

- (UIButton *(^)(CGFloat width,CGFloat Radius,UIColor *color))buttonLayer;
/**
 *  添加block点击事件
 */
- (void)bk_buttonControlEvents:(UIControlEvents)controlEvents handler:(void(^)(UIButton *sender))action;


/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(LOSERButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;
@end
