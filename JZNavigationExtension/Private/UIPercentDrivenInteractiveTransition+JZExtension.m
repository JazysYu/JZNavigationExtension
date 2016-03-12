//
//  UIPercentDrivenInteractiveTransition+JZExtension.m
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 3/11/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import "UIPercentDrivenInteractiveTransition+JZExtension.h"
#import "_JZ-objc-internal.h"
#import "UINavigationBar+JZExtension.h"
#import "UIViewController+JZExtension.h"
#import "UINavigationController+JZExtension.h"

@implementation UIPercentDrivenInteractiveTransition (JZExtension)

- (void)jz_handleInteractiveTransition:(BOOL)isCancel {
    
    if (![self isMemberOfClass:NSClassFromString(@"_UINavigationInteractiveTransition")]) {
        return;
    }
    
    UINavigationController *navigationController = (UINavigationController *)[self jz_parent];
    UIViewController *adjustViewController = isCancel ? navigationController.jz_interactivePopedViewController : navigationController.visibleViewController;
    navigationController.jz_navigationBarBackgroundAlpha = adjustViewController.jz_navigationBarBackgroundAlpha;
    navigationController.navigationBar.barTintColor = adjustViewController.jz_navigationBarTintColor;
    !navigationController.jz_interactivePopGestureRecognizerCompletion ?: navigationController.jz_interactivePopGestureRecognizerCompletion(navigationController,isCancel ? nil : navigationController.jz_interactivePopedViewController, !isCancel);
    navigationController.jz_interactivePopedViewController = nil;
}

- (void)jz_updateInteractiveTransition:(CGFloat)percentComplete {
    
    [self jz_updateInteractiveTransition:percentComplete];
    
    if (![self isMemberOfClass:NSClassFromString(@"_UINavigationInteractiveTransition")]) {
        return;
    }
    
    UINavigationController *navigationController = (UINavigationController *)[self jz_parent];
    
    if (navigationController.jz_interactivePopedViewController.jz_navigationBarBackgroundAlpha != navigationController.visibleViewController.jz_navigationBarBackgroundAlpha) {
        CGFloat _percentComplete = percentComplete * (navigationController.visibleViewController.jz_navigationBarBackgroundAlpha - navigationController.jz_interactivePopedViewController.jz_navigationBarBackgroundAlpha) + navigationController.jz_interactivePopedViewController.jz_navigationBarBackgroundAlpha;
        [[navigationController.navigationBar jz_backgroundView] setAlpha:_percentComplete];
    }
    
    if (!CGColorEqualToColor(navigationController.jz_interactivePopedViewController.jz_navigationBarTintColor.CGColor, navigationController.visibleViewController.jz_navigationBarTintColor.CGColor)) {
        CGFloat red1, green1, blue1, alpha1;
        CGFloat red2, green2, blue2, alpha2;
        [navigationController.jz_interactivePopedViewController.jz_navigationBarTintColor getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
        [navigationController.visibleViewController.jz_navigationBarTintColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
        red1 += percentComplete * (red2 - red1);
        green1 += percentComplete * (green2 - green1);
        blue1 += percentComplete * (blue2 - blue1);
        alpha1 += percentComplete * (alpha2 - alpha1);
        navigationController.navigationBar.barTintColor = [UIColor colorWithRed:red1 green:green1 blue:blue1 alpha:alpha1];
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
