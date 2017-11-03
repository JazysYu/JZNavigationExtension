//
//  _JZNavigationControllerDelegate.m
//  JZNavigationExtension2
//
//  Created by Jazys on 8/29/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import "_JZNavigationDelegating.h"
#import "UIViewController+JZExtension.h"
#import "UINavigationController+JZExtension.h"
#import "_JZ-objc-internal.h"
#import "UINavigationBar+JZExtension.h"

typedef void (*JZNavigationShowViewControllerIMP)(id _Nonnull, SEL _Nonnull, UINavigationController *, UIViewController *, BOOL);

static NSString *kSnapshotLayerNameForTransition = @"JZNavigationExtensionSnapshotLayerName";

@interface _JZNavigationDelegating()
@property (nonatomic, weak) UINavigationController *navigationController;
@end

@implementation _JZNavigationDelegating

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        self.navigationController = navigationController;
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (![navigationController.delegate isEqual:navigationController.jz_navigationDelegate]) {
        Class superClass = class_getSuperclass(object_getClass(self));
        JZNavigationShowViewControllerIMP superInstanceMethod = (void *)class_getMethodImplementation(superClass, _cmd);
        superInstanceMethod(self, _cmd, navigationController, viewController, animated);
    }
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = navigationController.topViewController.transitionCoordinator;
    navigationController.jz_previousVisibleViewController = [transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    if ([navigationController.viewControllers containsObject:navigationController.jz_previousVisibleViewController]) {
        navigationController.jz_operation = UINavigationControllerOperationPush;
    } else {
        navigationController.jz_operation = UINavigationControllerOperationPop;
    }
    
    [transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        !navigationController.jz_interactivePopGestureRecognizerCompletion ?: navigationController.jz_interactivePopGestureRecognizerCompletion(navigationController, !context.isCancelled);
        
        UIViewController *adjustViewController = context.isCancelled ? navigationController.jz_previousVisibleViewController : navigationController.visibleViewController;
        
        if (context.isCancelled) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(context.percentComplete * context.transitionDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (!navigationController.transitionCoordinator.isInteractive) {
                    !navigationController.jz_navigationTransitionStyleObserving ?: navigationController.jz_navigationTransitionStyleObserving();
                }
            });
            UIColor *newNavigationBarColor = [adjustViewController jz_navigationBarTintColorWithNavigationController:navigationController];
            navigationController.jz_navigationBarTintColor = newNavigationBarColor;
            //        navigationController.jz_navigationBarBackgroundAlpha = [adjustViewController jz_navigationBarBackgroundAlphaWithNavigationController:navigationController];
            navigationController.jz_operation = UINavigationControllerOperationNone;
            [navigationController jz_previousVisibleViewController];
        } else {
            [navigationController setNavigationBarHidden:![adjustViewController jz_wantsNavigationBarVisibleWithNavigationController:navigationController] animated:animated];
        }
        
    }];
    
    if (![[navigationController valueForKey:@"isBuiltinTransition"] boolValue] || !navigationController.navigationBar.isTranslucent || navigationController.jz_navigationBarTransitionStyle == JZNavigationBarTransitionStyleSystem) {
        
        [navigationController setNavigationBarHidden:![viewController jz_wantsNavigationBarVisibleWithNavigationController:navigationController] animated:animated];
        
        [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            navigationController.jz_navigationBarTintColor = [viewController jz_navigationBarTintColorWithNavigationController:navigationController];
            //            navigationController.jz_navigationBarBackgroundAlpha = [viewController jz_navigationBarBackgroundAlphaWithNavigationController:navigationController];
        } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        }];
        
    } else if (navigationController.jz_navigationBarTransitionStyle == JZNavigationBarTransitionStyleDoppelganger) {
        
        UIView *snapshotView = [UIApplication sharedApplication].keyWindow;
        
        JZNavigationBarTransitionStyle navigationBarTransitionStyle = navigationController.jz_navigationBarTransitionStyle;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(navigationController.navigationBar.bounds.size.width, navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + 0.1), NO, 0.0);
        
        if (!navigationController.navigationBarHidden) {
            [snapshotView drawViewHierarchyInRect:snapshotView.bounds afterScreenUpdates:false];
        }
        
        static CALayer * (^_snapshotLayerWithImage) (UIImage *snapshotImage) = ^CALayer *(UIImage *snapshotImage) {
            CALayer *snapshotLayer = [CALayer layer];
            snapshotLayer.name = kSnapshotLayerNameForTransition;
            snapshotLayer.contents = (__bridge id _Nullable)snapshotImage.CGImage;
            snapshotLayer.contentsScale = snapshotImage.scale;
            snapshotLayer.frame = (CGRect){CGPointZero, snapshotImage.size};
            return snapshotLayer;
        };
        
        if (!navigationController.navigationBarHidden) {
            [navigationController.jz_previousVisibleViewController.view.layer addSublayer:_snapshotLayerWithImage(UIGraphicsGetImageFromCurrentImageContext())];
        }
        
        navigationController.navigationBarHidden = ![viewController jz_wantsNavigationBarVisibleWithNavigationController:navigationController];
        navigationController.jz_navigationBarTintColor = [viewController jz_navigationBarTintColorWithNavigationController:navigationController];
        navigationController.jz_navigationBarBackgroundAlpha = [viewController jz_navigationBarBackgroundAlphaWithNavigationController:navigationController];
        
        CGFloat navigationBarAlpha = navigationController.navigationBar.alpha;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (!navigationController.jz_navigationTransitionStyleObserving) {
                UIGraphicsEndImageContext();
                return;
            }
            
            [snapshotView.layer renderInContext:UIGraphicsGetCurrentContext()];
            
            if (!navigationController.navigationBarHidden) {
                
                CALayer *snapshotLayer = _snapshotLayerWithImage(UIGraphicsGetImageFromCurrentImageContext());
                
                if (navigationBarTransitionStyle == JZNavigationBarTransitionStyleDoppelganger) {
                    [viewController.view.layer addSublayer:snapshotLayer];
                } else {
                    [navigationController.navigationBar.superview.layer addSublayer:snapshotLayer];
                }
                
            }
            
            UIGraphicsEndImageContext();
            
            navigationController.navigationBar.alpha = 0.f;
            
        });
        
        __weak typeof(navigationController) weakSelf = navigationController;
        
        navigationController.jz_navigationTransitionStyleObserving = ^{
            
            weakSelf.jz_navigationTransitionStyleObserving = NULL;
            
            if (![viewController isEqual:weakSelf.visibleViewController]) {
                UIViewController *toViewController = weakSelf.visibleViewController;
                weakSelf.navigationBarHidden = ![toViewController jz_wantsNavigationBarVisibleWithNavigationController:weakSelf];
                weakSelf.jz_navigationBarTintColor = toViewController.jz_navigationBarTintColor;
                weakSelf.jz_navigationBarBackgroundAlpha = [toViewController jz_navigationBarBackgroundAlphaWithNavigationController:weakSelf];
            }
            
            weakSelf.navigationBar.alpha = navigationBarAlpha;
            
            NSPredicate *getSubSnapshotLayerPredicate = [NSPredicate predicateWithFormat:@"name == %@", kSnapshotLayerNameForTransition];
            NSArray <CALayer *> *result = nil;
            if (navigationBarTransitionStyle == JZNavigationBarTransitionStyleDoppelganger) {
                result = [navigationController.jz_previousVisibleViewController.view.layer.sublayers filteredArrayUsingPredicate:getSubSnapshotLayerPredicate];
                [result makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
                result = [viewController.view.layer.sublayers filteredArrayUsingPredicate:getSubSnapshotLayerPredicate];
                [result makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
            } else {
                result = [weakSelf.navigationBar.superview.layer.sublayers filteredArrayUsingPredicate:getSubSnapshotLayerPredicate];
                [result makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
            }
            
        };
        
    }
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (![navigationController.delegate isEqual:navigationController.jz_navigationDelegate]) {
        Class superClass = class_getSuperclass(object_getClass(self));
        JZNavigationShowViewControllerIMP superInstanceMethod = (void *)class_getMethodImplementation(superClass, _cmd);
        superInstanceMethod(self, _cmd, navigationController, viewController, animated);
    }
    
    !navigationController.jz_navigationTransitionCompletion ?: navigationController.jz_navigationTransitionCompletion(navigationController, true);
    navigationController.jz_navigationTransitionCompletion = NULL;
    !navigationController.jz_navigationTransitionStyleObserving ?: navigationController.jz_navigationTransitionStyleObserving();
    navigationController.jz_operation = UINavigationControllerOperationNone;
    [navigationController jz_previousVisibleViewController];
    
}

#pragma mark - gestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UINavigationController *navigationController = self.navigationController;
    return navigationController.viewControllers.count != 1 && ![navigationController transitionCoordinator] && !CGRectContainsPoint(navigationController.navigationBar.frame, [touch locationInView:gestureRecognizer.view]);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    UINavigationController *navigationController = self.navigationController;
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

@end
