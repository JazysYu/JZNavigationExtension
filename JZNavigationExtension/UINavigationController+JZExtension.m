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

#import "UINavigationController+JZExtension.h"
#import "_JZ-objc-internal.h"
#import "UIToolbar+JZExtension.h"
#import "UINavigationBar+JZExtension.h"
#import "UIViewController+JZExtension.h"
#import "UIPercentDrivenInteractiveTransition+JZExtension.h"

@implementation UINavigationController (JZExtension)

__attribute__((constructor)) static void JZ_Inject(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        void (^__method_swizzling)(Class, SEL, SEL) = ^(Class cls, SEL sel, SEL _sel) {
            Method  method = class_getInstanceMethod(cls, sel);
            Method _method = class_getInstanceMethod(cls, _sel);
            method_exchangeImplementations(method, _method);
        };
        /**
         *  rewrite the implementation of interactivePopGestureRecognizer's delegate.
         */
        {
            Class _UINavigationInteractiveTransition = NSClassFromString(@"_UINavigationInteractiveTransition");
            
            {
                Method gestureShouldReceiveTouch = class_getInstanceMethod(_UINavigationInteractiveTransition, @selector(gestureRecognizer:shouldReceiveTouch:));
                method_setImplementation(gestureShouldReceiveTouch, imp_implementationWithBlock(^(UIPercentDrivenInteractiveTransition *navTransition,UIGestureRecognizer *gestureRecognizer, UITouch *touch){
                    UINavigationController *navigationController = (UINavigationController *)[navTransition jz_parent];
                    return navigationController.viewControllers.count != 1 && ![navigationController jz_isTransitioning] && !CGRectContainsPoint(navigationController.navigationBar.frame, [touch locationInView:gestureRecognizer.view]);
                }));
            }
            
            {
                NSString *selectorString = [NSString stringWithFormat:@"_%@",NSStringFromSelector(@selector(gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer:))];
                Method gestureShouldSimultaneouslyGesture = class_getInstanceMethod(_UINavigationInteractiveTransition, NSSelectorFromString(selectorString));
                method_setImplementation(gestureShouldSimultaneouslyGesture, imp_implementationWithBlock(^(UIPercentDrivenInteractiveTransition *navTransition, UIPanGestureRecognizer *gestureRecognizer){
                    UINavigationController *navigationController = (UINavigationController *)[navTransition jz_parent];
                    if (!navigationController.jz_fullScreenInteractivePopGestureRecognizer) {
                        return true;
                    }
                    CGPoint locationInView = [gestureRecognizer locationInView:gestureRecognizer.view];
                    return locationInView.x < 30.0f;
                }));
                
            }
            
            {
                Method gestureRecognizerShouldBegin = class_getInstanceMethod(_UINavigationInteractiveTransition, @selector(gestureRecognizerShouldBegin:));
                method_setImplementation(gestureRecognizerShouldBegin, imp_implementationWithBlock(^(UIPercentDrivenInteractiveTransition *navTransition, UIPanGestureRecognizer *gestureRecognizer){
                    CGPoint velocityInview = [gestureRecognizer velocityInView:gestureRecognizer.view];
                    return velocityInview.x >= 0.0f;
                }));
            }
            
            {
                __method_swizzling([UIPercentDrivenInteractiveTransition class], @selector(updateInteractiveTransition:), @selector(jz_updateInteractiveTransition:));
            }
            
            {
                __method_swizzling([UIPercentDrivenInteractiveTransition class], @selector(cancelInteractiveTransition), @selector(jz_cancelInteractiveTransition));
            }
            
            {
                __method_swizzling([UIPercentDrivenInteractiveTransition class], @selector(finishInteractiveTransition), @selector(jz_finishInteractiveTransition));
            }
            
            {
                __method_swizzling([UINavigationBar class], @selector(sizeThatFits:), @selector(jz_sizeThatFits:));
            }
            
            {
                __method_swizzling([UIToolbar class], @selector(sizeThatFits:), @selector(jz_sizeThatFits:));
            }
        }
        
        {
            
            {
                __method_swizzling([UINavigationController class], @selector(pushViewController:animated:),@selector(jz_pushViewController:animated:));
            }
            
            {
                __method_swizzling([UINavigationController class], @selector(popViewControllerAnimated:), @selector(jz_popViewControllerAnimated:));
            }
            
            {
                __method_swizzling([UINavigationController class], @selector(popToViewController:animated:), @selector(jz_popToViewController:animated:));
            }
            
            {
                __method_swizzling([UINavigationController class], @selector(popToRootViewControllerAnimated:), @selector(jz_popToRootViewControllerAnimated:));
            }
            
            {
                __method_swizzling([UINavigationController class], NSSelectorFromString(@"navigationTransitionView:didEndTransition:fromView:toView:"),@selector(jz_navigationTransitionView:didEndTransition:fromView:toView:));
            }
            
        }
    });
}

- (void)jz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    self._jz_navigationTransitionFinished = completion;
    UIViewController *visibleViewController = [self visibleViewController];
    [self jz_pushViewController:viewController animated:animated];
    [self jz_navigationWillTransitFromViewController:visibleViewController toViewController:viewController animated:animated isInterActiveTransition:NO];
}

- (UIViewController *)jz_popViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL))completion {
    self._jz_navigationTransitionFinished = completion;
    UIViewController *viewController = [self jz_popViewControllerAnimated:animated];
    UIViewController *visibleViewController = [self visibleViewController];
    [self jz_navigationWillTransitFromViewController:viewController toViewController:visibleViewController animated:animated isInterActiveTransition:YES];
    return viewController;
}

- (NSArray *)jz_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    self._jz_navigationTransitionFinished = completion;
    NSArray *popedViewControllers = [self jz_popToViewController:viewController animated:animated];
    UIViewController *topPopedViewController = [popedViewControllers lastObject];
    [self jz_navigationWillTransitFromViewController:topPopedViewController toViewController:viewController animated:animated isInterActiveTransition:NO];
    return popedViewControllers;
}

- (NSArray *)jz_popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    self._jz_navigationTransitionFinished = completion;
    NSArray *popedViewControllers = [self jz_popToRootViewControllerAnimated:animated];
    UIViewController *topPopedViewController = [popedViewControllers lastObject];
    UIViewController *topViewController = [self.viewControllers firstObject];
    [self jz_navigationWillTransitFromViewController:topPopedViewController toViewController:topViewController animated:animated isInterActiveTransition:NO];
    return popedViewControllers;
}

#pragma mark - private funcs

- (void)jz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self jz_pushViewController:viewController animated:animated completion:NULL];
}

- (UIViewController *)jz_popViewControllerAnimated:(BOOL)animated {
    return [self jz_popViewControllerAnimated:animated completion:NULL];
}

- (NSArray *)jz_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    return [self jz_popToViewController:viewController animated:animated completion:NULL];
}

- (NSArray *)jz_popToRootViewControllerAnimated:(BOOL)animated {
    return [self jz_popToRootViewControllerAnimated:animated completion:NULL];
}

- (void)jz_navigationTransitionView:(id)arg1 didEndTransition:(int)arg2 fromView:(id)arg3 toView:(id)arg4 {
    [self jz_navigationTransitionView:arg1 didEndTransition:arg2 fromView:arg3 toView:arg4];
    !self._jz_navigationTransitionFinished ?: self._jz_navigationTransitionFinished(YES);
}

- (void)jz_navigationWillTransitFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController animated:(BOOL)animated isInterActiveTransition:(BOOL)isInterActiveTransition {
    [self setNavigationBarHidden:!toViewController.jz_wantsNavigationBarVisible animated:animated];
    void (^_updateNavigationBarBackgroundAlpha)() = ^{
        if (fromViewController.jz_navigationBarBackgroundAlpha != toViewController.jz_navigationBarBackgroundAlpha) {
            [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.f animations:^{
                [self setJz_navigationBarBackgroundAlpha:toViewController.jz_navigationBarBackgroundAlpha];
            }];
        }
        if (!CGColorEqualToColor(fromViewController.jz_navigationBarTintColor.CGColor, toViewController.jz_navigationBarTintColor.CGColor)) {
            CGFloat red, green, blue, alpha;
            [toViewController.jz_navigationBarTintColor getRed:&red green:&green blue:&blue alpha:&alpha];
            [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration: 0.f animations:^{
                self.navigationBar.barTintColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
            }];
        }
    };
    if (!isInterActiveTransition) {
        _updateNavigationBarBackgroundAlpha();
    } else {
        if (![self jz_isInteractiveTransition]) {
            _updateNavigationBarBackgroundAlpha();
        } else
            self.jz_interactivePopedViewController = fromViewController;
    }
}

#pragma mark - setters

- (void)setJz_fullScreenInteractivePopGestureRecognizer:(BOOL)jz_fullScreenInteractivePopGestureRecognizer {
    if (jz_fullScreenInteractivePopGestureRecognizer) {
        if ([self.interactivePopGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]]) return;
        object_setClass(self.interactivePopGestureRecognizer, [UIPanGestureRecognizer class]);
        [self.interactivePopGestureRecognizer setValue:@NO forKey:@"canPanVertically"];
    } else {
        if ([self.interactivePopGestureRecognizer isMemberOfClass:[UIScreenEdgePanGestureRecognizer class]]) return;
        object_setClass(self.interactivePopGestureRecognizer, [UIScreenEdgePanGestureRecognizer class]);
    }
}

- (void)setJz_toolbarBackgroundAlpha:(CGFloat)jz_toolbarBackgroundAlpha {
    [[self.toolbar jz_shadowView] setAlpha:jz_toolbarBackgroundAlpha];
    [[self.toolbar jz_backgroundView] setAlpha:jz_toolbarBackgroundAlpha];
}

- (void)setJz_navigationBarBackgroundAlpha:(CGFloat)jz_navigationBarBackgroundAlpha {
    [[self.navigationBar jz_backgroundView] setAlpha:jz_navigationBarBackgroundAlpha];
}

- (void)setJz_navigationBarSize:(CGSize)jz_navigationBarSize {
    [self.navigationBar setJz_size:jz_navigationBarSize];
}

- (void)setJz_toolbarSize:(CGSize)jz_toolbarSize {
    [self.toolbar setJz_size:jz_toolbarSize];
}

- (void)set_jz_navigationTransitionFinished:(void (^)(BOOL))_jz_navigationTransitionFinished {
    objc_setAssociatedObject(self, @selector(_jz_navigationTransitionFinished), _jz_navigationTransitionFinished, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setJz_interactivePopedViewController:(UIViewController *)jz_interactivePopedViewController {
    objc_setAssociatedObject(self, @selector(jz_interactivePopedViewController), jz_interactivePopedViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJz_interactivePopGestureRecognizerCompletion:(void (^)(UINavigationController *, UIViewController *, BOOL))jz_interactivePopGestureRecognizerCompletion {
    objc_setAssociatedObject(self, @selector(jz_interactivePopGestureRecognizerCompletion), jz_interactivePopGestureRecognizerCompletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - getters

- (CGFloat)jz_navigationBarBackgroundAlpha {
    return [[self.navigationBar jz_backgroundView] alpha];
}

- (CGFloat)jz_toolbarBackgroundAlpha {
    return [[self.toolbar jz_backgroundView] alpha];
}

- (BOOL)jz_fullScreenInteractivePopGestureRecognizer {
    return [self.interactivePopGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]];
}

- (void (^)(BOOL))_jz_navigationTransitionFinished {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(UINavigationController *, UIViewController *, BOOL))jz_interactivePopGestureRecognizerCompletion {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIViewController *)jz_interactivePopedViewController {
    return objc_getAssociatedObject(self, _cmd);
}

- (CGSize)jz_navigationBarSize {
    return [self.navigationBar jz_size];
}

- (CGSize)jz_toolbarSize {
    return [self.toolbar jz_size];
}

- (BOOL)jz_isInteractiveTransition {
    return [objc_getProperty(self, @"isInteractiveTransition") boolValue];
}

- (BOOL)jz_isTransitioning {
    return [objc_getProperty(self, @"_isTransitioning") boolValue];
}

- (UIViewController *)jz_previousViewControllerForViewController:(UIViewController *)viewController {
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    
    if (!index) return nil;
    
    return self.viewControllers[index - 1];
}

@end
