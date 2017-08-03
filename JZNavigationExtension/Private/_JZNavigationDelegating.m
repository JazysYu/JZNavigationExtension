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

static NSString *kSnapshotLayerNameForTransition = @"JZNavigationExtensionSnapshotLayerName";

@interface NSObject (JZExtension) <UINavigationControllerDelegate>
@end

@implementation _JZNavigationDelegating

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (navigationController.jz_navigationBarTransitionStyle == JZNavigationBarTransitionStyleSystem) {
        [navigationController setNavigationBarHidden:![viewController jz_wantsNavigationBarVisibleWithNavigationController:navigationController] animated:animated];
        [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.f animations:^{
            navigationController.jz_navigationBarTintColor = [viewController jz_navigationBarTintColorWithNavigationController:navigationController];
            navigationController.jz_navigationBarBackgroundAlpha = [viewController jz_navigationBarBackgroundAlphaWithNavigationController:navigationController];
        }];
    } else if (navigationController.jz_navigationBarTransitionStyle == JZNavigationBarTransitionStyleDoppelganger) {
        
        UIView *snapshotView = [UIApplication sharedApplication].keyWindow;
        
        JZNavigationBarTransitionStyle navigationBarTransitionStyle = navigationController.jz_navigationBarTransitionStyle;
        
//        if (objc_getAssociatedObject(navigationController, @selector(jz_navigationBarTransitionStyle))) {
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
                
                if (!navigationController.jz_didEndNavigationTransitionBlock) {
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
            
            navigationController.jz_didEndNavigationTransitionBlock = ^{
                
                weakSelf.jz_didEndNavigationTransitionBlock = NULL;
                
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
            
//        }
        
    }
 
//    IMP superIMP = [super methodForSelector:_cmd];
//    IMP selfIMP = [self methodForSelector:_cmd];
//    if (superIMP != selfIMP) {
//        [super navigationController:navigationController willShowViewController:viewController animated:animated];
//    }
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    !navigationController._jz_navigationTransitionFinished ?: navigationController._jz_navigationTransitionFinished(navigationController, true);
    navigationController._jz_navigationTransitionFinished = NULL;
    !navigationController.jz_didEndNavigationTransitionBlock ?: navigationController.jz_didEndNavigationTransitionBlock();
    navigationController.jz_operation = UINavigationControllerOperationNone;
    [navigationController jz_previousVisibleViewController];
}

//- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
//    return 0;
//}
//
//- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController {
//    return 0;
//}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return nil;
//    navigationController._jz_interactiveTransition;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    navigationController.jz_operation = operation;
    navigationController.jz_previousVisibleViewController = fromVC;
    return nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([[NSString stringWithUTF8String:sel_getName(aSelector)] isEqualToString:@"navigationController:animationControllerForOperation:fromViewController:toViewController:"]) {
        return false;
    }
     return true;
}

/**
 *  @author JazysYu, 16-08-29 18:08:52
 *
 *  Fake the class
 */
//- (Class)class {
//    return [super superclass];
//}

@end
