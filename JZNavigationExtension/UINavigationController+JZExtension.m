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
#import <objc/runtime.h>
#import <objc/message.h>

#define objc_getProperty(objc,key) [objc valueForKey:key]
@implementation NSNumber (JZExtension)
- (CGFloat)CGFloatValue {
#if CGFLOAT_IS_DOUBLE
    return [self doubleValue];
#else
    return [self floatValue];
#endif
}
@end

@interface UINavigationController (_JZExtension)
@property (nonatomic, copy) void (^interactivePopGestureRecognizerCompletion)(UINavigationController *, UIViewController *, BOOL);
@property (nonatomic, copy) void (^_push_pop_Finished)(BOOL);
- (void)setInteractivePopedViewController:(UIViewController *)interactivePopedViewController;
- (BOOL)jz_isTransitioning;
- (BOOL)jz_isInteractiveTransition;
@end

@interface UIPercentDrivenInteractiveTransition (JZExtension)
- (id)__parent;
- (void)_updateInteractiveTransition:(CGFloat)percentComplete;
- (void)_cancelInteractiveTransition;
- (void)_finishInteractiveTransition;
@end

@protocol JZExtensionBarProtocol <NSObject>
@property (nonatomic, assign) CGSize size;
- (UIView * _Nullable)__backgroundView;
- (CGSize)_sizeThatFits:(CGSize)size;
@end

@interface UINavigationBar (JZExtension) <JZExtensionBarProtocol>
@end

@interface UIToolbar (JZExtension) <JZExtensionBarProtocol>
- (UIView * _Nullable)__shadowView;
@end

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
                    UINavigationController *navigationController = (UINavigationController *)[navTransition __parent];
                    return navigationController.viewControllers.count != 1 && ![navigationController jz_isTransitioning] && !CGRectContainsPoint(navigationController.navigationBar.frame, [touch locationInView:gestureRecognizer.view]);
                }));
            }
            
            {
                NSString *selectorString = [NSString stringWithFormat:@"_%@",NSStringFromSelector(@selector(gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer:))];
                Method gestureShouldSimultaneouslyGesture = class_getInstanceMethod(_UINavigationInteractiveTransition, NSSelectorFromString(selectorString));
                method_setImplementation(gestureShouldSimultaneouslyGesture, imp_implementationWithBlock(^(UIPercentDrivenInteractiveTransition *navTransition, UIPanGestureRecognizer *gestureRecognizer){
                    UINavigationController *navigationController = (UINavigationController *)[navTransition __parent];
                    if (!navigationController.fullScreenInteractivePopGestureRecognizer) {
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
                __method_swizzling([UIPercentDrivenInteractiveTransition class], @selector(updateInteractiveTransition:), @selector(_updateInteractiveTransition:));
            }
            
            {
                __method_swizzling([UIPercentDrivenInteractiveTransition class], @selector(cancelInteractiveTransition), @selector(_cancelInteractiveTransition));
            }
            
            {
                __method_swizzling([UIPercentDrivenInteractiveTransition class], @selector(finishInteractiveTransition), @selector(_finishInteractiveTransition));
            }
            
            {
                __method_swizzling([UINavigationBar class], @selector(sizeThatFits:), @selector(_sizeThatFits:));
            }
            
            {
                __method_swizzling([UIToolbar class], @selector(sizeThatFits:), @selector(_sizeThatFits:));
            }
        }
        
        {
            
            {
                __method_swizzling([UINavigationController class], @selector(pushViewController:animated:),@selector(_pushViewController:animated:));
            }
            
            {
                __method_swizzling([UINavigationController class], @selector(popViewControllerAnimated:), @selector(_popViewControllerAnimated:));
            }
            
            {
                __method_swizzling([UINavigationController class], @selector(popToViewController:animated:), @selector(_popToViewController:animated:));
            }
            
            {
                __method_swizzling([UINavigationController class], @selector(popToRootViewControllerAnimated:), @selector(_popToRootViewControllerAnimated:));
            }
            
            {
                __method_swizzling([UINavigationController class], NSSelectorFromString(@"navigationTransitionView:didEndTransition:fromView:toView:"),@selector(jz_navigationTransitionView:didEndTransition:fromView:toView:));
            }
            
        }
    });
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    self._push_pop_Finished = completion;
    UIViewController *visibleViewController = [self visibleViewController];
    [self _pushViewController:viewController animated:animated];
    [self _navigationWillTransitFromViewController:visibleViewController toViewController:viewController animated:animated isInterActiveTransition:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL))completion {
    self._push_pop_Finished = completion;
    UIViewController *viewController = [self _popViewControllerAnimated:animated];
    UIViewController *visibleViewController = [self visibleViewController];
    [self _navigationWillTransitFromViewController:viewController toViewController:visibleViewController animated:animated isInterActiveTransition:YES];
    return viewController;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    self._push_pop_Finished = completion;
    NSArray *popedViewControllers = [self _popToViewController:viewController animated:animated];
    UIViewController *topPopedViewController = [popedViewControllers lastObject];
    [self _navigationWillTransitFromViewController:topPopedViewController toViewController:viewController animated:animated isInterActiveTransition:NO];
    return popedViewControllers;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    self._push_pop_Finished = completion;
    NSArray *popedViewControllers = [self _popToRootViewControllerAnimated:animated];
    UIViewController *topPopedViewController = [popedViewControllers lastObject];
    UIViewController *topViewController = [self.viewControllers firstObject];
    [self _navigationWillTransitFromViewController:topPopedViewController toViewController:topViewController animated:animated isInterActiveTransition:NO];
    return popedViewControllers;
}

#pragma mark - private funcs

- (void)_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self pushViewController:viewController animated:animated completion:NULL];
}

- (UIViewController *)_popViewControllerAnimated:(BOOL)animated {
    return [self popViewControllerAnimated:animated completion:NULL];
}

- (NSArray *)_popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    return [self popToViewController:viewController animated:animated completion:NULL];
}

- (NSArray *)_popToRootViewControllerAnimated:(BOOL)animated {
    return [self popToRootViewControllerAnimated:animated completion:NULL];
}

- (void)jz_navigationTransitionView:(id)arg1 didEndTransition:(int)arg2 fromView:(id)arg3 toView:(id)arg4 {
    [self jz_navigationTransitionView:arg1 didEndTransition:arg2 fromView:arg3 toView:arg4];
    !self._push_pop_Finished ?: self._push_pop_Finished(YES);
}

- (void)_navigationWillTransitFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController animated:(BOOL)animated isInterActiveTransition:(BOOL)isInterActiveTransition {
    [self setNavigationBarHidden:!toViewController.wantsNavigationBarVisible animated:animated];
    void (^_updateNavigationBarBackgroundAlpha)() = ^{
        if (fromViewController.navigationBarBackgroundAlpha != toViewController.navigationBarBackgroundAlpha) {
            [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.f animations:^{
                [self setNavigationBarBackgroundAlpha:toViewController.navigationBarBackgroundAlpha];
            }];
        }
        if (!CGColorEqualToColor(fromViewController.navigationBarTintColor.CGColor, toViewController.navigationBarTintColor.CGColor)) {
            CGFloat red, green, blue, alpha;
            [toViewController.navigationBarTintColor getRed:&red green:&green blue:&blue alpha:&alpha];
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
            self.interactivePopedViewController = fromViewController;
    }
}

#pragma mark - setters

- (void)setFullScreenInteractivePopGestureRecognizer:(BOOL)fullScreenInteractivePopGestureRecognizer {
    if (fullScreenInteractivePopGestureRecognizer) {
        if ([self.interactivePopGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]]) return;
        object_setClass(self.interactivePopGestureRecognizer, [UIPanGestureRecognizer class]);
        [self.interactivePopGestureRecognizer setValue:@NO forKey:@"canPanVertically"];
    } else {
        if ([self.interactivePopGestureRecognizer isMemberOfClass:[UIScreenEdgePanGestureRecognizer class]]) return;
        object_setClass(self.interactivePopGestureRecognizer, [UIScreenEdgePanGestureRecognizer class]);
    }
}

- (void)setToolbarBackgroundAlpha:(CGFloat)toolbarBackgroundAlpha {
    [[self.toolbar __shadowView] setAlpha:toolbarBackgroundAlpha];
    [[self.toolbar __backgroundView] setAlpha:toolbarBackgroundAlpha];
}

- (void)setNavigationBarBackgroundAlpha:(CGFloat)navigationBarBackgroundAlpha {
    [[self.navigationBar __backgroundView] setAlpha:navigationBarBackgroundAlpha];
}

- (void)setNavigationBarSize:(CGSize)navigationBarSize {
    [self.navigationBar setSize:navigationBarSize];
}

- (void)setToolbarSize:(CGSize)toolbarSize {
    [self.toolbar setSize:toolbarSize];
}

- (void)set_push_pop_Finished:(void (^)(BOOL))_push_pop_Finished {
    objc_setAssociatedObject(self, @selector(_push_pop_Finished), _push_pop_Finished, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setInteractivePopedViewController:(UIViewController *)interactivePopedViewController {
    objc_setAssociatedObject(self, @selector(interactivePopedViewController), interactivePopedViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setInteractivePopGestureRecognizerCompletion:(void (^)(UINavigationController *, UIViewController *, BOOL))completion {
    objc_setAssociatedObject(self, @selector(interactivePopGestureRecognizerCompletion), completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - getters

- (CGFloat)navigationBarBackgroundAlpha {
    return [[self.navigationBar __backgroundView] alpha];
}

- (CGFloat)toolbarBackgroundAlpha {
    return [[self.toolbar __backgroundView] alpha];
}

- (BOOL)fullScreenInteractivePopGestureRecognizer {
    return [self.interactivePopGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]];
}

- (void (^)(BOOL))_push_pop_Finished {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(UINavigationController *, UIViewController *, BOOL))interactivePopGestureRecognizerCompletion {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIViewController *)interactivePopedViewController {
    return objc_getAssociatedObject(self, _cmd);
}

- (CGSize)navigationBarSize {
    return [self.navigationBar size];
}

- (CGSize)toolbarSize {
    return [self.toolbar size];
}

- (BOOL)jz_isInteractiveTransition {
    return [objc_getProperty(self, @"isInteractiveTransition") boolValue];
}

- (BOOL)jz_isTransitioning {
    return [objc_getProperty(self, @"_isTransitioning") boolValue];
}

- (UIViewController *)previousViewControllerForViewController:(UIViewController *)viewController {
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    
    if (!index) return nil;
    
    return self.viewControllers[index - 1];
}

@end

@implementation UIViewController (JZExtension)

- (UIViewController *)previousViewController {
    return self.navigationController ? [self.navigationController previousViewControllerForViewController:self] : nil;
}

- (void)setNavigationBarBackgroundHidden:(BOOL)navigationBarBackgroundHidden {
    [self setNavigationBarBackgroundAlpha:0.0f];
}

- (void)setNavigationBarBackgroundAlpha:(CGFloat)navigationBarBackgroundAlpha {
    [self.navigationController setNavigationBarBackgroundAlpha:navigationBarBackgroundAlpha];
    objc_setAssociatedObject(self, @selector(navigationBarBackgroundAlpha), @(navigationBarBackgroundAlpha), OBJC_ASSOCIATION_COPY);
}

- (void)setNavigationBarBackgroundHidden:(BOOL)navigationBarBackgroundHidden animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.f animations:^{
        [self setNavigationBarBackgroundHidden:navigationBarBackgroundHidden];
    }];
}

- (void)setNavigationBarTintColor:(UIColor *)navigationBarTintColor {
    self.navigationController.navigationBar.barTintColor = navigationBarTintColor;
    self.navigationController.navigationBar.alpha = 0.9;
    objc_setAssociatedObject(self, @selector(navigationBarTintColor), navigationBarTintColor, OBJC_ASSOCIATION_RETAIN);
}

- (void)setWantsNavigationBarVisible:(BOOL)wantsNavigationBarVisible {
    objc_setAssociatedObject(self, @selector(wantsNavigationBarVisible), @(wantsNavigationBarVisible), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isNavigationBarBackgroundHidden {
    return self.navigationBarBackgroundAlpha - 0.0f <= 0.0001;
}

- (CGFloat)navigationBarBackgroundAlpha {
    id _navigationBarBackgroundAlpha = objc_getAssociatedObject(self, _cmd);
    return _navigationBarBackgroundAlpha != nil ? [_navigationBarBackgroundAlpha CGFloatValue] : 1.f;
}

- (BOOL)wantsNavigationBarVisible {
    id _wantsNavigationBarVisible = objc_getAssociatedObject(self, _cmd);
    return _wantsNavigationBarVisible != nil ? [_wantsNavigationBarVisible boolValue] : YES;
}

- (UIColor *)navigationBarTintColor {
    UIColor *_navigationBarTintColor = objc_getAssociatedObject(self, _cmd);
    if (!_navigationBarTintColor) {
        _navigationBarTintColor = self.navigationController.navigationBar.barTintColor;
        if (!_navigationBarTintColor) {
            _navigationBarTintColor = [UIColor colorWithWhite:self.navigationController.navigationBar.barStyle == UIBarStyleDefault alpha:1.0];
        }
        self.navigationBarTintColor = _navigationBarTintColor;
    }
    return _navigationBarTintColor;
}

@end

#define JZExtensionBarImplementation \
- (CGSize)_sizeThatFits:(CGSize)size { \
CGSize newSize = [self _sizeThatFits:size]; \
return CGSizeMake(self.size.width == 0.f ? newSize.width : self.size.width, self.size.height == 0.f ? newSize.height : self.size.height); \
} \
- (void)setSize:(CGSize)size { \
objc_setAssociatedObject(self, @selector(size), [NSValue valueWithCGSize:size], OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
[self sizeToFit]; \
} \
- (CGSize)size { \
return [objc_getAssociatedObject(self, _cmd) CGSizeValue]; \
} \
- (UIView *)__backgroundView { \
return objc_getProperty(self, @"_backgroundView"); \
}

@implementation UIToolbar (JZExtension)

JZExtensionBarImplementation

- (UIView *)__shadowView {
    return objc_getProperty(self, @"_shadowView");
}

@end

@implementation UINavigationBar (JZExtension)

JZExtensionBarImplementation

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([[self __backgroundView] alpha] < 1.0f) {
        return CGRectContainsPoint(CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44), point);
    } else {
        return [super pointInside:point withEvent:event];
    }
}

@end

@implementation UIPercentDrivenInteractiveTransition (JZExtension)

- (void)_handleInteractiveTransition:(BOOL)isCancel {
    if (![self isMemberOfClass:NSClassFromString(@"_UINavigationInteractiveTransition")]) {
        return;
    }
    
    UINavigationController *navigationController = (UINavigationController *)[self __parent];
    UIViewController *adjustViewController = isCancel ? navigationController.interactivePopedViewController : navigationController.visibleViewController;
    navigationController.navigationBarBackgroundAlpha = adjustViewController.navigationBarBackgroundAlpha;
    navigationController.navigationBar.barTintColor = adjustViewController.navigationBarTintColor;
    !navigationController.interactivePopGestureRecognizerCompletion ?: navigationController.interactivePopGestureRecognizerCompletion(navigationController,isCancel ? nil : navigationController.interactivePopedViewController, !isCancel);
    navigationController.interactivePopedViewController = nil;
}

- (void)_updateInteractiveTransition:(CGFloat)percentComplete {
    [self _updateInteractiveTransition:percentComplete];
    if (![self isMemberOfClass:NSClassFromString(@"_UINavigationInteractiveTransition")]) {
        return;
    }
    
    UINavigationController *navigationController = (UINavigationController *)[self __parent];
    
    if (navigationController.interactivePopedViewController.navigationBarBackgroundAlpha != navigationController.visibleViewController.navigationBarBackgroundAlpha) {
        CGFloat _percentComplete = percentComplete * (navigationController.visibleViewController.navigationBarBackgroundAlpha - navigationController.interactivePopedViewController.navigationBarBackgroundAlpha) + navigationController.interactivePopedViewController.navigationBarBackgroundAlpha;
        [[navigationController.navigationBar __backgroundView] setAlpha:_percentComplete];
    }
    
    if (!CGColorEqualToColor(navigationController.interactivePopedViewController.navigationBarTintColor.CGColor, navigationController.visibleViewController.navigationBarTintColor.CGColor)) {
        CGFloat red1, green1, blue1, alpha1;
        CGFloat red2, green2, blue2, alpha2;
        [navigationController.interactivePopedViewController.navigationBarTintColor getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
        [navigationController.visibleViewController.navigationBarTintColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
        red1 += percentComplete * (red2 - red1);
        green1 += percentComplete * (green2 - green1);
        blue1 += percentComplete * (blue2 - blue1);
        alpha1 += percentComplete * (alpha2 - alpha1);
        navigationController.navigationBar.barTintColor = [UIColor colorWithRed:red1 green:green1 blue:blue1 alpha:alpha1];
    }
}

- (void)_cancelInteractiveTransition {
    [self _cancelInteractiveTransition];
    [self _handleInteractiveTransition:YES];
}

- (void)_finishInteractiveTransition {
    [self _finishInteractiveTransition];
    [self _handleInteractiveTransition:NO];
}

- (id)__parent {
    return objc_getProperty(self, @"_parent");
}

@end
