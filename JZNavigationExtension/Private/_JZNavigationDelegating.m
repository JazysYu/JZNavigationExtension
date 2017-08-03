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

@interface NSObject (JZExtension) <UINavigationControllerDelegate>
@end

@implementation _JZNavigationDelegating

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [navigationController setNavigationBarHidden:![viewController jz_wantsNavigationBarVisibleWithNavigationController:navigationController] animated:animated];
    [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.f animations:^{
        navigationController.jz_navigationBarTintColor = [viewController jz_navigationBarTintColorWithNavigationController:navigationController];
        navigationController.jz_navigationBarBackgroundAlpha = [viewController jz_navigationBarBackgroundAlphaWithNavigationController:navigationController];
    }];
 
//    IMP superIMP = [super methodForSelector:_cmd];
//    IMP selfIMP = [self methodForSelector:_cmd];
//    if (superIMP != selfIMP) {
//        [super navigationController:navigationController willShowViewController:viewController animated:animated];
//    }
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    !navigationController._jz_navigationTransitionFinished ?: navigationController._jz_navigationTransitionFinished(navigationController, true);
    navigationController._jz_navigationTransitionFinished = NULL;
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

//- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
//                                            animationControllerForOperation:(UINavigationControllerOperation)operation
//                                                         fromViewController:(UIViewController *)fromVC
//                                                           toViewController:(UIViewController *)toVC {
//    navigationController.jz_operation = operation;
//    navigationController.jz_previousVisibleViewController = fromVC;
//    return nil;
//}

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
