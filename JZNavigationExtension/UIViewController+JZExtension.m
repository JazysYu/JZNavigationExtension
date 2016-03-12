//
//  UIViewController+JZExtension.m
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 3/11/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import "UIViewController+JZExtension.h"
#import "UINavigationController+JZExtension.h"
#import "NSNumber+JZExtension.h"
#import <objc/runtime.h>

@implementation UIViewController (JZExtension)

- (UIViewController *)jz_previousViewController {
    return self.navigationController ? [self.navigationController jz_previousViewControllerForViewController:self] : nil;
}

- (void)setJz_navigationBarBackgroundHidden:(BOOL)jz_navigationBarBackgroundHidden {
    [self setJz_navigationBarBackgroundAlpha:0.0f];
}

- (void)setJz_navigationBarBackgroundAlpha:(CGFloat)jz_navigationBarBackgroundAlpha {
    [self.navigationController setJz_navigationBarBackgroundAlpha:jz_navigationBarBackgroundAlpha];
    objc_setAssociatedObject(self, @selector(jz_navigationBarBackgroundAlpha), @(jz_navigationBarBackgroundAlpha), OBJC_ASSOCIATION_COPY);
}

- (void)setJz_navigationBarBackgroundHidden:(BOOL)jz_navigationBarBackgroundHidden animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.f animations:^{
        [self setJz_navigationBarBackgroundHidden:jz_navigationBarBackgroundHidden];
    }];
}

- (void)setJz_navigationBarTintColor:(UIColor *)jz_navigationBarTintColor {
    self.navigationController.navigationBar.barTintColor = jz_navigationBarTintColor;
    self.navigationController.navigationBar.alpha = 0.9;
    objc_setAssociatedObject(self, @selector(jz_navigationBarTintColor), jz_navigationBarTintColor, OBJC_ASSOCIATION_RETAIN);
}

- (void)setJz_wantsNavigationBarVisible:(BOOL)jz_wantsNavigationBarVisible {
    objc_setAssociatedObject(self, @selector(jz_wantsNavigationBarVisible), @(jz_wantsNavigationBarVisible), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isJz_navigationBarBackgroundHidden {
    return self.jz_navigationBarBackgroundAlpha - 0.0f <= 0.0001;
}

- (CGFloat)jz_navigationBarBackgroundAlpha {
    id _navigationBarBackgroundAlpha = objc_getAssociatedObject(self, _cmd);
    return _navigationBarBackgroundAlpha != nil ? [_navigationBarBackgroundAlpha jz_CGFloatValue] : 1.f;
}

- (BOOL)jz_wantsNavigationBarVisible {
    id _wantsNavigationBarVisible = objc_getAssociatedObject(self, _cmd);
    return _wantsNavigationBarVisible != nil ? [_wantsNavigationBarVisible boolValue] : YES;
}

- (UIColor *)jz_navigationBarTintColor {
    UIColor *_navigationBarTintColor = objc_getAssociatedObject(self, _cmd);
    if (!_navigationBarTintColor) {
        _navigationBarTintColor = self.navigationController.navigationBar.barTintColor;
        if (!_navigationBarTintColor) {
            _navigationBarTintColor = [UIColor colorWithWhite:self.navigationController.navigationBar.barStyle == UIBarStyleDefault alpha:1.0];
        }
        self.jz_navigationBarTintColor = _navigationBarTintColor;
    }
    return _navigationBarTintColor;
}

@end
