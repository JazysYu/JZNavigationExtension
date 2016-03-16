//
//  UIPercentDrivenInteractiveTransition+JZExtension.m
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 3/11/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import "UIPercentDrivenInteractiveTransition+JZExtension.h"
#import "_JZ-objc-internal.h"
#import "NSNumber+JZExtension.h"
#import "UINavigationBar+JZExtension.h"
#import "UIViewController+JZExtension.h"
#import "UINavigationController+JZExtension.h"

@implementation UIPercentDrivenInteractiveTransition (JZExtension)

CG_INLINE CGFloat _getNavigationBarBackgroundAlpha(UINavigationController *navigationController, UIViewController *viewController) {
    id _navigationBarBackgroundAlphaAssociatedObject = objc_getAssociatedObject(viewController, @selector(jz_navigationBarBackgroundAlpha));
    CGFloat _navigationBarBackgroundAlpha = [_navigationBarBackgroundAlphaAssociatedObject jz_CGFloatValue];
    if (!_navigationBarBackgroundAlphaAssociatedObject) {
        _navigationBarBackgroundAlpha = navigationController.jz_navigationBarBackgroundAlpha;
    }
    return _navigationBarBackgroundAlpha;
}

CG_INLINE UIColor *_getNavigationBarTintColor(UINavigationController *navigationController, UIViewController *viewController) {
    id _navigationBarTintColorAssociatedObject = objc_getAssociatedObject(viewController, @selector(jz_navigationBarTintColor));
    if (!viewController.jz_hasNavigationBarTintColorSetterBeenCalled) {
        if (!_navigationBarTintColorAssociatedObject) {
            _navigationBarTintColorAssociatedObject = navigationController.jz_navigationBarTintColor;
        }
    }

    return _navigationBarTintColorAssociatedObject;
}

- (void)jz_handleInteractiveTransition:(BOOL)isCancel {
    
    if (![self isMemberOfClass:JZ_UINavigationInteractiveTransition]) {
        return;
    }

    UINavigationController *navigationController = (UINavigationController *)[self jz_parent];
    UIViewController *adjustViewController = isCancel ? navigationController.jz_previousVisibleViewController : navigationController.visibleViewController;
    navigationController.jz_navigationBarBackgroundAlpha = _getNavigationBarBackgroundAlpha(navigationController, adjustViewController);
    navigationController.jz_navigationBarTintColor = _getNavigationBarTintColor(navigationController, adjustViewController);
    !navigationController.jz_interactivePopGestureRecognizerCompletion ?: navigationController.jz_interactivePopGestureRecognizerCompletion(navigationController, !isCancel);
}

- (void)jz_updateInteractiveTransition:(CGFloat)percentComplete {
    
    [self jz_updateInteractiveTransition:percentComplete];
    
    if (![self isMemberOfClass:JZ_UINavigationInteractiveTransition]) {
        return;
    }
    
    UINavigationController *navigationController = (UINavigationController *)[self jz_parent];

    CGFloat _interactivePopedViewController_navigationBarBackgroundAlpha = _getNavigationBarBackgroundAlpha(navigationController, navigationController.jz_previousVisibleViewController);
    if (_interactivePopedViewController_navigationBarBackgroundAlpha != navigationController.visibleViewController.jz_navigationBarBackgroundAlpha) {
        CGFloat _percentComplete = percentComplete * (navigationController.visibleViewController.jz_navigationBarBackgroundAlpha - _interactivePopedViewController_navigationBarBackgroundAlpha) + _interactivePopedViewController_navigationBarBackgroundAlpha;
        navigationController.jz_navigationBarBackgroundAlpha = _percentComplete;
    }
    
    UIColor *_interactivePopedViewController_navigationBarTintColor = _getNavigationBarTintColor(navigationController, navigationController.jz_previousVisibleViewController);
    if (_interactivePopedViewController_navigationBarTintColor != navigationController.visibleViewController.jz_navigationBarTintColor) {
        CGFloat red1, green1, blue1, alpha1;
        CGFloat red2, green2, blue2, alpha2;
        [_interactivePopedViewController_navigationBarTintColor getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
        [navigationController.visibleViewController.jz_navigationBarTintColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
        red1 += percentComplete * (red2 - red1);
        green1 += percentComplete * (green2 - green1);
        blue1 += percentComplete * (blue2 - blue1);
        alpha1 += percentComplete * (alpha2 - alpha1);
        navigationController.jz_navigationBarTintColor = [UIColor colorWithRed:red1 green:green1 blue:blue1 alpha:alpha1];
    }
}

- (void)jz_cancelInteractiveTransition {
    [self jz_cancelInteractiveTransition];
    [self jz_handleInteractiveTransition:YES];
}

- (void)jz_finishInteractiveTransition {
    [self jz_finishInteractiveTransition];
    [self jz_handleInteractiveTransition:NO];
}

- (id)jz_parent {
    return objc_getProperty(self, @"_parent");
}

@end
