// The MIT License (MIT)
//
// Copyright (c) 2015-present JazysYu ( https://github.com/JazysYu )
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
#import "UINavigationController+JZExtension.h"

@implementation UIViewController (JZExtension)

- (void)setJz_wantsNavigationBarVisible:(BOOL)jz_wantsNavigationBarVisible {
    self.jz_navigationBarHidden = !jz_wantsNavigationBarVisible;
}

- (BOOL)jz_wantsNavigationBarVisible {
    return !self.jz_navigationBarHidden;
}

- (void)setJz_navigationBarHidden:(BOOL)jz_navigationBarHidden {
    objc_setAssociatedObject(self, @selector(jz_navigationBarHidden), @(jz_navigationBarHidden), OBJC_ASSOCIATION_ASSIGN);
    [self.navigationController setNavigationBarHidden:jz_navigationBarHidden animated:true];
}

- (BOOL)jz_navigationBarHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)jz_navigationBarHiddenWithNavigationController:(UINavigationController *)navigationController {
    
    id jz_navigationBarHidden = objc_getAssociatedObject(self, @selector(jz_navigationBarHidden));
    if (jz_navigationBarHidden) {
        return [jz_navigationBarHidden boolValue];
    }
    
    jz_navigationBarHidden = objc_getAssociatedObject(navigationController, @selector(jz_navigationBarHidden));
    if (jz_navigationBarHidden) {
        return [jz_navigationBarHidden boolValue];
    }
    
    return navigationController.isNavigationBarHidden;
    
}

- (void)setJz_navigationBarBackgroundAlpha:(CGFloat)jz_navigationBarBackgroundAlpha {
    objc_setAssociatedObject(self, @selector(jz_navigationBarBackgroundAlpha), @(jz_navigationBarBackgroundAlpha), OBJC_ASSOCIATION_RETAIN);
    self.navigationController.jz_navigationBarBackgroundAlphaReal = jz_navigationBarBackgroundAlpha;
}

- (CGFloat)jz_navigationBarBackgroundAlpha {
    return [objc_getAssociatedObject(self, _cmd) jz_CGFloatValue];
}

- (CGFloat)jz_navigationBarBackgroundAlphaWithNavigationController:(UINavigationController *)navigationController {
    
    id jz_navigationBarBackgroundAlpha = objc_getAssociatedObject(self, @selector(jz_navigationBarBackgroundAlpha));
    if (jz_navigationBarBackgroundAlpha) {
        return [jz_navigationBarBackgroundAlpha jz_CGFloatValue];
    }
    
    jz_navigationBarBackgroundAlpha = objc_getAssociatedObject(navigationController, @selector(jz_navigationBarBackgroundAlpha));
    if (jz_navigationBarBackgroundAlpha) {
        return [jz_navigationBarBackgroundAlpha jz_CGFloatValue];
    }

    return navigationController.navigationBar.jz_backgroundView.alpha;
    
}

- (void)setJz_navigationBarTintColor:(UIColor *)jz_navigationBarTintColor {
    self.jz_navigationBarTintColorSetterBeenCalled = true;
    objc_setAssociatedObject(self, @selector(jz_navigationBarTintColor), jz_navigationBarTintColor, OBJC_ASSOCIATION_RETAIN);
    self.navigationController.navigationBar.barTintColor = jz_navigationBarTintColor;
}

- (UIColor *)jz_navigationBarTintColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIColor *)jz_navigationBarTintColorWithNavigationController:(UINavigationController *)navigationController {
    
    if (self.jz_hasNavigationBarTintColorSetterBeenCalled) {
        return self.jz_navigationBarTintColor;
    }
    
    if (navigationController.jz_hasNavigationBarTintColorSetterBeenCalled) {
        return navigationController.jz_navigationBarTintColor;
    }
    
    return navigationController.navigationBar.barTintColor;
    
}

- (void)setJz_navigationBarTintColorSetterBeenCalled:(BOOL)jz_navigationBarTintColorSetterBeenCalled {
    objc_setAssociatedObject(self, @selector(jz_hasNavigationBarTintColorSetterBeenCalled), @(jz_navigationBarTintColorSetterBeenCalled), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)jz_hasNavigationBarTintColorSetterBeenCalled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setJz_navigationInteractivePopGestureEnabled:(BOOL)jz_navigationInteractivePopGestureEnabled {
    objc_setAssociatedObject(self, @selector(jz_navigationInteractivePopGestureEnabled), @(jz_navigationInteractivePopGestureEnabled), OBJC_ASSOCIATION_ASSIGN);
    self.navigationController.interactivePopGestureRecognizer.enabled = jz_navigationInteractivePopGestureEnabled;
}

- (BOOL)jz_navigationInteractivePopGestureEnabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)jz_navigationInteractivePopGestureEnabledWithNavigationController:(UINavigationController *)navigationController {
    
    id jz_navigationInteractivePopGestureEnabled = objc_getAssociatedObject(self, @selector(jz_navigationInteractivePopGestureEnabled));
    if (jz_navigationInteractivePopGestureEnabled) {
        return [jz_navigationInteractivePopGestureEnabled boolValue];
    }
    
    jz_navigationInteractivePopGestureEnabled = objc_getAssociatedObject(navigationController, @selector(jz_navigationInteractivePopGestureEnabled));
    if (jz_navigationInteractivePopGestureEnabled) {
        return [jz_navigationInteractivePopGestureEnabled boolValue];
    }
    
    return navigationController.interactivePopGestureRecognizer.isEnabled;
    
}

- (void)jz_setNavigationBarBackgroundHidden:(BOOL)jz_navigationBarBackgroundHidden animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            [self jz_setNavigationBarBackgroundHidden:jz_navigationBarBackgroundHidden];
        }];
    } else {
        [self jz_setNavigationBarBackgroundHidden:jz_navigationBarBackgroundHidden];
    }
}

- (void)jz_setNavigationBarBackgroundHidden:(BOOL)jz_navigationBarBackgroundHidden {
    [self setJz_navigationBarBackgroundAlpha:!jz_navigationBarBackgroundHidden];
}

- (BOOL)jz_isNavigationBarBackgroundHidden {
    return fabs(self.jz_navigationBarBackgroundAlpha - 0.0f) <= 0.0001;
}

- (UIViewController *)jz_previousViewController {
    return self.navigationController ? [self.navigationController jz_previousViewControllerForViewController:self] : nil;
}

@end
