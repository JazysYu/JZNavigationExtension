//
//  _JZNavigationControllerDelegate.m
//  
//
//  Created by Jazys on 8/29/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import "_JZNavigationDelegating.h"
#import "_JZ-objc-internal.h"
#import "UIViewController+JZExtension.h"
#import "UINavigationController+JZExtension.h"

@interface _JZNavigationDelegating()
@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, copy) dispatch_block_t actionsPerformInDealloc;
@end

@implementation _JZNavigationDelegating

- (void)dealloc {
    !self.actionsPerformInDealloc ?: self.actionsPerformInDealloc();
}

- (instancetype)initWithActionsPerformInDealloc:(dispatch_block_t)actionsPerformInDealloc {
    self = [super init];
    if (self) {
        self.actionsPerformInDealloc = actionsPerformInDealloc;
    }
    return self;
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        self.navigationController = navigationController;
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = navigationController.topViewController.transitionCoordinator;
    
    void (^animateAlongsideTransition)(id <UIViewControllerTransitionCoordinatorContext>) = NULL;
    void (^completion)(id <UIViewControllerTransitionCoordinatorContext>) = NULL;
    
    if (![[navigationController valueForKey:@"isBuiltinTransition"] boolValue] || !navigationController.navigationBar.isTranslucent || navigationController.jz_navigationBarTransitionStyle == JZNavigationBarTransitionStyleSystem) {
        
        [navigationController setNavigationBarHidden:[viewController jz_navigationBarHiddenWithNavigationController:navigationController] animated:animated];
        animateAlongsideTransition = ^(id<UIViewControllerTransitionCoordinatorContext> context) {
            navigationController.navigationBar.barTintColor = [viewController jz_navigationBarTintColorWithNavigationController:navigationController];
            navigationController.jz_navigationBarBackgroundAlphaReal = [viewController jz_navigationBarBackgroundAlphaWithNavigationController:navigationController];
        };

    } else if (navigationController.jz_navigationBarTransitionStyle == JZNavigationBarTransitionStyleDoppelganger) {
        
        static NSString *_JZNavigationExtensionSnapshotLayerName = @"JZNavigationExtensionSnapshotLayerName";
        
        static CALayer * (^_snapshotLayerWithImage) (UIImage *snapshotImage) = ^CALayer *(UIImage *snapshotImage) {
            CALayer *snapshotLayer = [CALayer layer];
            snapshotLayer.name = _JZNavigationExtensionSnapshotLayerName;
            snapshotLayer.contents = (__bridge id _Nullable)snapshotImage.CGImage;
            snapshotLayer.contentsScale = snapshotImage.scale;
            snapshotLayer.frame = (CGRect){CGPointZero, snapshotImage.size};
            return snapshotLayer;
        };
        
        UIView *snapshotView = [UIApplication sharedApplication].keyWindow;
        
        JZNavigationBarTransitionStyle navigationBarTransitionStyle = navigationController.jz_navigationBarTransitionStyle;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(navigationController.navigationBar.bounds.size.width, navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + 0.1), NO, 0.0);
        
        if (!navigationController.isNavigationBarHidden) {
            [snapshotView drawViewHierarchyInRect:snapshotView.bounds afterScreenUpdates:false];
            [navigationController.jz_previousVisibleViewController.view.layer addSublayer:_snapshotLayerWithImage(UIGraphicsGetImageFromCurrentImageContext())];
        }
        
        navigationController.navigationBarHidden = [viewController jz_navigationBarHiddenWithNavigationController:navigationController];
        navigationController.navigationBar.barTintColor = [viewController jz_navigationBarTintColorWithNavigationController:navigationController];
        navigationController.jz_navigationBarBackgroundAlphaReal = [viewController jz_navigationBarBackgroundAlphaWithNavigationController:navigationController];
        
        CGFloat navigationBarAlpha = navigationController.navigationBar.alpha;
        
        __block BOOL isDoppelgangerCompleted = false;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (isDoppelgangerCompleted) {
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
        
        completion = ^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            
            isDoppelgangerCompleted = true;
            
            if (![viewController isEqual:navigationController.visibleViewController]) {
                navigationController.navigationBarHidden = [navigationController.visibleViewController jz_navigationBarHiddenWithNavigationController:navigationController];
            }
            
            navigationController.navigationBar.alpha = navigationBarAlpha;
            
            NSPredicate *getSubSnapshotLayerPredicate = [NSPredicate predicateWithFormat:@"name == %@", _JZNavigationExtensionSnapshotLayerName];
            NSArray <CALayer *> *result = nil;
            if (navigationBarTransitionStyle == JZNavigationBarTransitionStyleDoppelganger) {
                result = [navigationController.jz_previousVisibleViewController.view.layer.sublayers filteredArrayUsingPredicate:getSubSnapshotLayerPredicate];
                [result makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
                result = [viewController.view.layer.sublayers filteredArrayUsingPredicate:getSubSnapshotLayerPredicate];
                [result makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
            } else {
                result = [navigationController.navigationBar.superview.layer.sublayers filteredArrayUsingPredicate:getSubSnapshotLayerPredicate];
                [result makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
            }
            
        };
        
    }
    
    [transitionCoordinator animateAlongsideTransition:animateAlongsideTransition completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        
        if (context.initiallyInteractive) {
            
            UIViewController *adjustViewController = context.isCancelled ? navigationController.jz_previousVisibleViewController : navigationController.visibleViewController;
            
            if (context.isCancelled) {
                navigationController.navigationBar.barTintColor = [adjustViewController jz_navigationBarTintColorWithNavigationController:navigationController];
                navigationController.jz_navigationBarBackgroundAlphaReal = [adjustViewController jz_navigationBarBackgroundAlphaWithNavigationController:navigationController];
            } else {
                [navigationController setNavigationBarHidden:[adjustViewController jz_navigationBarHiddenWithNavigationController:navigationController] animated:animated];
            }
            
            !navigationController.jz_interactivePopGestureRecognizerCompletion ?: navigationController.jz_interactivePopGestureRecognizerCompletion(navigationController, !context.isCancelled);
            
        }
        
        !completion ?: completion(context);
        
        navigationController.interactivePopGestureRecognizer.enabled = [navigationController.visibleViewController jz_navigationInteractivePopGestureEnabledWithNavigationController:navigationController];
        
        !navigationController.jz_navigationTransitionCompletion ?: navigationController.jz_navigationTransitionCompletion(navigationController, true);
        navigationController.jz_navigationTransitionCompletion = NULL;
        navigationController.jz_operation = UINavigationControllerOperationNone;
        navigationController.jz_previousVisibleViewController = nil;
        
    }];
    
    if (![navigationController.delegate isEqual:navigationController.jz_navigationDelegate]) {
        Class superClass = class_getSuperclass(object_getClass(self));
        void (*superIMP)(id _Nonnull, SEL _Nonnull, UINavigationController *, UIViewController *, BOOL) = (void *)class_getMethodImplementation(superClass, _cmd);
        superIMP(self, _cmd, navigationController, viewController, animated);
    }
    
}

#pragma mark - gestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    UINavigationController *navigationController = self.navigationController;
    return navigationController.viewControllers.count != 1 && ![navigationController transitionCoordinator] && !CGRectContainsPoint(navigationController.navigationBar.frame, [touch locationInView:gestureRecognizer.view]);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (!self.navigationController.jz_fullScreenInteractivePopGestureEnabled) {
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
