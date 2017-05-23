//
//  UIView+LDViewExtension.h
//  百思不得姐
//
//  Created by Ringo on 2016/12/23.
//  Copyright © 2016年 Ringo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LDViewExtension)
+(instancetype)viewFromXib;

-(BOOL)intersectWithView:(UIView*)view;

@end
