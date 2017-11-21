//
//  UIButton+Category.m
//  masonry链式编程
//
//  Created by Loser on 16/11/25.
//  Copyright © 2016年 Mac. All rights reserved.
//



#import "UIButton+Category.h"
#import<objc/runtime.h>

static const void *myButtonaction = &myButtonaction;



@implementation UIButton (Category)



- (UIButton *(^)(NSString *))buttonNormalTitle
{
    return ^UIButton *(NSString *Normaltitle){
        
        [self setTitle:Normaltitle forState:UIControlStateNormal];
        return self;
    };
}
- (UIButton *(^)(UIColor *))buttonNormalColor
{
    return ^UIButton *(UIColor *NormalColor){
        [self setTitleColor:NormalColor forState:UIControlStateNormal];
        return self;
    };
}

-(UIButton *(^)(UIImage *))buttonNormalImg
{
    return ^UIButton *(UIImage *normalImg){
        [self setImage:normalImg forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton *(^)(NSString *))buttonSelecteTitle
{
    return ^UIButton *(NSString *selecteTitle){
        [self setTitle:selecteTitle forState:UIControlStateSelected];
        return self;
    };
}

- (UIButton *(^)(UIColor *))buttonSelecteColor
{
    return ^UIButton *(UIColor *selecteColor){
        [self setTitleColor:selecteColor forState:UIControlStateSelected];
        return self;
    };
}

- (UIButton *(^)(UIImage *))buttonSelecteImg
{
    return ^UIButton *(UIImage *selecteImg){
        [self setImage:selecteImg forState:UIControlStateSelected];
        return self;
    };
}

- (UIButton *(^)(UIImage *))buttonHighlighted
{
    return ^UIButton *(UIImage * hei){
      
        [self setImage:hei forState:UIControlStateHighlighted];
        
        return self;
    };
}

- (UIButton *(^)(CGRect))buttonFrame
{
    return ^UIButton *(CGRect frame){
        self.frame = frame;
        return self;
    };
}

- (UIButton *(^)(float))buttonSystemFont
{
    return ^UIButton *(float fontSize){
        [self.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
        return self;
    };
}

- (UIButton *(^)(NSUInteger))buttonTag
{
    return ^UIButton *(NSUInteger tag){
        self.tag = tag;
        return self;
    };
}

- (UIButton *(^)(id target,SEL action,UIControlEvents ControlEvents))buttonAddClickAction
{
    return ^UIButton *(id target,SEL action,UIControlEvents controlEvents){
        [self addTarget:target action:action forControlEvents:controlEvents];
        return self;
    };
}

- (UIButton *(^)(CGFloat width,CGFloat Radius,UIColor *color))buttonLayer
{
    return ^UIButton *(CGFloat width,CGFloat Radius,UIColor *color){
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = width;
        self.layer.cornerRadius = Radius;
        return self;
    };
}

- (void)bk_buttonControlEvents:(UIControlEvents)controlEvents handler:(void(^)(UIButton *sender))action
{
    [self addTarget:self action:@selector(bk_handleAction:) forControlEvents:controlEvents];
    objc_setAssociatedObject(self, myButtonaction, action, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    NSLog(@"%@",objc_getAssociatedObject(self, myButtonaction));
}

- (void)bk_handleAction:(UIButton *)sender
{
    
//    NSLog(@"%@",objc_getAssociatedObject(self, myButtonaction));
    void (^block)(UIButton *sender) = objc_getAssociatedObject(self, myButtonaction);
    if (block) {
        block(sender);
    }
}


- (void)layoutButtonWithEdgeInsetsStyle:(LOSERButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space
{
    //    self.backgroundColor = [UIColor cyanColor];
    
    /**
     *  前置知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    
    // 1. 得到imageView和titleLabel的宽、高
    //    NSLog(@"%@",NSStringFromCGSize(self.imageView.image.size));
    CGFloat imageWith = self.imageView.image.size.width;
    CGFloat imageHeight = self.imageView.image.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case LOSERButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
            
            
        }
            break;
        case LOSERButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
            
        }
            break;
        case LOSERButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
            
        }
            break;
        case LOSERButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
            
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
    
}



@end
