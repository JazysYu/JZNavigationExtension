//
//  UIViewController+JZExtension.m
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 3/11/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import "UIViewController+JZExtension.h"
#import "_JZ-objc-internal.h"
#import "NSNumber+JZExtension.h"
#import "UINavigationController+JZExtension.h"

@implementation UIViewController (JZExtension)

- (void)setJz_navigationBarTintColorSetterBeenCalled:(BOOL)jz_navigationBarTintColorSetterBeenCalled {
    objc_setAssociatedObject(self, @selector(jz_hasNavigationBarTintColorSetterBeenCalled), @(jz_navigationBarTintColorSetterBeenCalled), OBJC_ASSOCIATION_ASSIGN);
}

- (void)jz_setNavigationBarBackgroundHidden:(BOOL)jz_navigationBarBackgroundHidden {
    [self setJz_navigationBarBackgroundAlpha:!jz_navigationBarBackgroundHidden];
}

- (void)setJz_navigationBarBackgroundAlpha:(CGFloat)jz_navigationBarBackgroundAlpha {
    [self.navigationController setJz_navigationBarBackgroundAlpha:jz_navigationBarBackgroundAlpha];
    objc_setAssociatedObject(self, @selector(jz_navigationBarBackgroundAlpha), @(jz_navigationBarBackgroundAlpha), OBJC_ASSOCIATION_RETAIN);
}

- (void)jz_setNavigationBarBackgroundHidden:(BOOL)jz_navigationBarBackgroundHidden animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.f animations:^{
        [self jz_setNavigationBarBackgroundHidden:jz_navigationBarBackgroundHidden];
    }];
}

- (void)setJz_navigationBarTintColor:(UIColor *)jz_navigationBarTintColor {
    self.jz_navigationBarTintColorSetterBeenCalled = true;
    [self.navigationController setJz_navigationBarTintColor:jz_navigationBarTintColor];
    objc_setAssociatedObject(self, @selector(jz_navigationBarTintColor), jz_navigationBarTintColor, OBJC_ASSOCIATION_RETAIN);
}

- (void)setJz_wantsNavigationBarVisible:(BOOL)jz_wantsNavigationBarVisible {
    objc_setAssociatedObject(self, @selector(jz_wantsNavigationBarVisible), @(jz_wantsNavigationBarVisible), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)jz_isNavigationBarBackgroundHidden {
    return self.jz_navigationBarBackgroundAlpha - 0.0f <= 0.0001;
}

- (BOOL)jz_wantsNavigationBarVisible {
    id _wantsNavigationBarVisible = objc_getAssociatedObject(self, _cmd);
    return _wantsNavigationBarVisible != nil ? [_wantsNavigationBarVisible boolValue] : YES;
}

- (BOOL)jz_hasNavigationBarTintColorSetterBeenCalled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (CGFloat)jz_navigationBarBackgroundAlpha {
    id _navigationBarBackgroundAlpha = objc_getAssociatedObject(self, _cmd);
    return _navigationBarBackgroundAlpha ? [_navigationBarBackgroundAlpha jz_CGFloatValue] : self.navigationController.jz_navigationBarBackgroundAlpha;
}

- (UIColor *)jz_navigationBarTintColor {
    UIColor *_navigationBarTintColor = objc_getAssociatedObject(self, _cmd);
    if (!self.jz_hasNavigationBarTintColorSetterBeenCalled) {
        return _navigationBarTintColor ? _navigationBarTintColor : self.navigationController.jz_navigationBarTintColor;
    } else {
        return _navigationBarTintColor;
    }
}

- (UIViewController *)jz_previousViewController {
    return self.navigationController ? [self.navigationController jz_previousViewControllerForViewController:self] : nil;
}

@end
