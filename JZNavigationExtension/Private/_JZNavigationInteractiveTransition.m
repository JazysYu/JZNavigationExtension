//
//  _JZNavigationInteractiveTransition.m
//
//  Created by Jazys on 4/23/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import "_JZNavigationInteractiveTransition.h"
#import <UIKit/UINavigationBar.h>
#import <UIKit/UINavigationController.h>
#import "JZNavigationExtension.h"
#import "NSNumber+JZExtension.h"
#import "UINavigationBar+JZExtension.h"
#import "_JZValue.h"
#import "_JZ-objc-internal.h"

static NSString *kNavigationController = @"__parent";

@interface _JZNavigationInteractiveTransition ()
{
    __weak UINavigationController *__parent;
}
@end
@implementation _JZNavigationInteractiveTransition

- (instancetype)initWithNavigationController:(id)navigationController {
    self = [super init];
    if (self) {
        __parent = navigationController;
    }
    return self;
}

#pragma mark - gestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UINavigationController *navigationController = [self valueForKey:kNavigationController];
    return navigationController.viewControllers.count != 1 && ![navigationController jz_isTransitioning] && !CGRectContainsPoint(navigationController.navigationBar.frame, [touch locationInView:gestureRecognizer.view]);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    UINavigationController *navigationController = [self valueForKey:kNavigationController];
    if (!navigationController.jz_fullScreenInteractivePopGestureEnabled) {
        return true;
    }
    CGPoint locationInView = [gestureRecognizer locationInView:gestureRecognizer.view];
    return locationInView.x < 30.0f;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint velocityInview = [gestureRecognizer velocityInView:gestureRecognizer.view];
    return velocityInview.x >= 0.0f;
}

#pragma mark - UIPercentDrivenInteractiveTransition

NS_INLINE void jz_handleInteractiveTransition(UIPercentDrivenInteractiveTransition *self, BOOL isCancel) {

    UINavigationController *navigationController = [self valueForKey:kNavigationController];
    UIViewController *adjustViewController = isCancel ? navigationController.jz_previousVisibleViewController : navigationController.visibleViewController;
    navigationController.jz_navigationBarBackgroundAlpha = [adjustViewController jz_navigationBarBackgroundAlphaWithNavigationController:navigationController];
    UIColor *newNavigationBarColor = [adjustViewController jz_navigationBarTintColorWithNavigationController:navigationController];
    navigationController.jz_navigationBarTintColor = newNavigationBarColor;
    !navigationController.jz_interactivePopGestureRecognizerCompletion ?: navigationController.jz_interactivePopGestureRecognizerCompletion(navigationController, !isCancel);
    [navigationController setValue:@(UINavigationControllerOperationNone) forKey:@"jz_operation"];
    if (jz_isVersionBelow9_0) {
        navigationController.jz_navigationBarTintColorView.backgroundColor = newNavigationBarColor;
        [CATransaction setCompletionBlock:^{
            [CATransaction setCompletionBlock:NULL];
            [navigationController.jz_navigationBarTintColorView removeFromSuperview];
        }];
    }
    if (isCancel) {
        if (navigationController.jz_didEndNavigationTransitionBlock) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.percentComplete * self.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!navigationController.jz_isInteractiveTransition) {
                    navigationController.jz_didEndNavigationTransitionBlock();
                }
            });
        }
    } else {
        if (navigationController.navigationBar.hidden) {
            navigationController.navigationBarHidden = true;
            navigationController.navigationBar.hidden = false;
        }
    }
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {

    [super updateInteractiveTransition:percentComplete];
    
    UINavigationController *navigationController = [self valueForKey:kNavigationController];

    CGFloat _interactivePopedViewController_navigationBarBackgroundAlpha = [navigationController.jz_previousVisibleViewController jz_navigationBarBackgroundAlphaWithNavigationController:navigationController];

    if (_interactivePopedViewController_navigationBarBackgroundAlpha != navigationController.visibleViewController.jz_navigationBarBackgroundAlpha) {
        CGFloat _percentComplete = percentComplete * (navigationController.visibleViewController.jz_navigationBarBackgroundAlpha - _interactivePopedViewController_navigationBarBackgroundAlpha) + _interactivePopedViewController_navigationBarBackgroundAlpha;
        navigationController.jz_navigationBarBackgroundAlpha = _percentComplete;
    }
    
    UIColor *_interactivePopedViewController_navigationBarTintColor = [navigationController.jz_previousVisibleViewController jz_navigationBarTintColorWithNavigationController:navigationController];
    
    if (_interactivePopedViewController_navigationBarTintColor != navigationController.visibleViewController.jz_navigationBarTintColor) {
        
        CGFloat red1, green1, blue1, alpha1;
        red1 = green1 = blue1 = alpha1 = 0.f;
        
        CGFloat red2, green2, blue2, alpha2;
        red2 = green2 = blue2 = alpha2 = 0.f;

        if (_interactivePopedViewController_navigationBarTintColor) {
            [_interactivePopedViewController_navigationBarTintColor getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
        }
        
        if (navigationController.visibleViewController.jz_navigationBarTintColor) {
            [navigationController.visibleViewController.jz_navigationBarTintColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
        }
        
        red1 += percentComplete * (red2 - red1);
        green1 += percentComplete * (green2 - green1);
        blue1 += percentComplete * (blue2 - blue1);
        alpha1 += percentComplete * (alpha2 - alpha1);

        UIColor *barTintColor = [UIColor colorWithRed:red1 green:green1 blue:blue1 alpha:alpha1];
        
        if (jz_isVersionBelow9_0) {
            if (!navigationController.jz_navigationBarTintColorView) {
                UIView *virtualViewForAnimation = [[UIView alloc] initWithFrame:navigationController.navigationBar.jz_backgroundView.bounds];
                virtualViewForAnimation.backgroundColor = _interactivePopedViewController_navigationBarTintColor;
                [navigationController.navigationBar.jz_backgroundView addSubview:virtualViewForAnimation];
                navigationController.jz_navigationBarTintColorView = virtualViewForAnimation;
            }
            navigationController.jz_navigationBarTintColorView.backgroundColor = barTintColor;
            navigationController.jz_navigationBarTintColor = navigationController.visibleViewController.jz_navigationBarTintColor;
        } else {
            navigationController.jz_navigationBarTintColor = barTintColor;
        }
        
    }
}

- (void)cancelInteractiveTransition {
    [super cancelInteractiveTransition];
    jz_handleInteractiveTransition(self, YES);
}

- (void)finishInteractiveTransition {
    [super finishInteractiveTransition];
    jz_handleInteractiveTransition(self, NO);
}

@end
