// The MIT License (MIT)
//
// Copyright (c) 2015-2016 JazysYu ( https://github.com/JazysYu )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "UIViewController+JZExtension.h"
#import "_JZ-objc-internal.h"
#import "NSNumber+JZExtension.h"
#import "UINavigationController+JZExtension.h"

@implementation UIViewController (JZExtension)

#pragma mark - Setter

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
    [self.navigationController setNavigationBarHidden:!jz_wantsNavigationBarVisible animated:true];
}

#pragma mark - Getter

- (BOOL)jz_isNavigationBarBackgroundHidden {
    return self.jz_navigationBarBackgroundAlpha - 0.0f <= 0.0001;
}

- (BOOL)jz_wantsNavigationBarVisible {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)jz_hasNavigationBarTintColorSetterBeenCalled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (CGFloat)jz_navigationBarBackgroundAlpha {
    return self.navigationController ? [self jz_navigationBarBackgroundAlphaWithNavigationController:self.navigationController] : 1.f;
}

- (UIColor *)jz_navigationBarTintColor {
    return [self jz_navigationBarTintColorWithNavigationController:self.navigationController];
}

- (UIViewController *)jz_previousViewController {
    return self.navigationController ? [self.navigationController jz_previousViewControllerForViewController:self] : nil;
}

#pragma mark - Private

- (BOOL)jz_wantsNavigationBarVisibleWithNavigationController:(UINavigationController *)navigationController {
    id jz_wantsNavigationBarVisibleObject = objc_getAssociatedObject(self, @selector(jz_wantsNavigationBarVisible));
    if (jz_wantsNavigationBarVisibleObject) {
        return [jz_wantsNavigationBarVisibleObject boolValue];
    }
    return !navigationController.navigationBarHidden;
}

- (UIColor *)jz_navigationBarTintColorWithNavigationController:(UINavigationController *)navigationController {
    UIColor *_navigationBarTintColor = objc_getAssociatedObject(self, @selector(jz_navigationBarTintColor));
    if (!self.jz_hasNavigationBarTintColorSetterBeenCalled) {
        return _navigationBarTintColor ? _navigationBarTintColor : navigationController.jz_navigationBarTintColor;
    } else {
        return _navigationBarTintColor;
    }
}

- (CGFloat)jz_navigationBarBackgroundAlphaWithNavigationController:(UINavigationController *)navigationController {
    id _navigationBarBackgroundAlpha = objc_getAssociatedObject(self, @selector(jz_navigationBarBackgroundAlpha));
    if (_navigationBarBackgroundAlpha) {
        return [_navigationBarBackgroundAlpha jz_CGFloatValue];
    }
    return navigationController.jz_navigationBarBackgroundAlpha;
}

@end
