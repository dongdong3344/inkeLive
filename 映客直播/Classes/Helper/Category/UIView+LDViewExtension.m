//
//  UIView+LDViewExtension.m
//  百思不得姐
//
//  Created by Ringo on 2016/12/23.
//  Copyright © 2016年 Ringo. All rights reserved.
//

#import "UIView+LDViewExtension.h"

@implementation UIView (LDViewExtension)

+(instancetype)viewFromXib{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

-(BOOL)intersectWithView:(UIView*)view{
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    CGRect selfRect=[self convertRect:self.bounds toView:window];
    CGRect viewRect=[view convertRect:view.bounds toView:window];
    
    return CGRectIntersectsRect(selfRect, viewRect);
    
}
@end
