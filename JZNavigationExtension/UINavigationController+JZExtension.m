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
#import "_JZValue.h"
#import "UIToolbar+JZExtension.h"
#import "UINavigationBar+JZExtension.h"
#import "UIViewController+JZExtension.h"
#import "_JZNavigationInteractiveTransition.h"

BOOL jz_isVersionBelow9_0 = false;

static NSString *kSnapshotLayerNameForTransition = @"JZNavigationExtensionSnapshotLayerName";

@implementation UINavigationController (JZExtension)

__attribute__((constructor)) static void JZ_Inject(void) {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        jz_isVersionBelow9_0 = [[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] == NSOrderedAscending;
        
        void (^jz_method_swizzling)(Class, SEL, SEL) = ^(Class cls, SEL sel, SEL _sel) {
            Method  method = class_getInstanceMethod(cls, sel);
            Method _method = class_getInstanceMethod(cls, _sel);
            method_exchangeImplementations(method, _method);
        };
        
        void (^jz_class_reImplementation)(Class, SEL, IMP) = ^(Class cls, SEL sel, IMP imp) {
            Method method = class_getInstanceMethod(cls, sel);
            if (!class_addMethod(cls, sel, imp, method_getTypeEncoding(method))) {
                method_setImplementation(method, imp);
            }
        };
        
        {
            Class cls_UINavigationInteractiveTransition = JZ_UINavigationInteractiveTransition;
            Class cls_JZNavigationInteractiveTransition = [_JZNavigationInteractiveTransition class];
            {
                static NSInvocation *(^jz_invocation_create)(id, SEL, void *) = ^NSInvocation *(id target, SEL selector, void *argument){
                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
                    [invocation setTarget:target];
                    [invocation setSelector:selector];
                    [invocation setArgument:argument atIndex:2];
                    [invocation retainArguments];
                    return invocation;
                };
                
                SEL sel_shouldReceiveTouch = @selector(gestureRecognizer:shouldReceiveTouch:);
                
                BOOL (*_originalShouldReceiveTouchIMP)(id, SEL, id, id) = (void *)[cls_UINavigationInteractiveTransition instanceMethodForSelector:sel_shouldReceiveTouch];
                
                Method method_shouldReceiveTouch = class_getInstanceMethod(cls_UINavigationInteractiveTransition, sel_shouldReceiveTouch);
                method_setImplementation(method_shouldReceiveTouch, imp_implementationWithBlock(^BOOL(id navigationTransition, id gestureRecognizer, id touch) {
                    
                    UINavigationController *navigationController = [navigationTransition valueForKey:@"__parent"];
                    
                    NSMutableArray<NSInvocation *> *invocations = [NSMutableArray array];
                    
                    if (navigationController.navigationBarHidden) {
                        BOOL navigationBarHidden = true;
                        [invocations addObject:jz_invocation_create(navigationController, @selector(setNavigationBarHidden:), &navigationBarHidden)];
                        navigationController.navigationBarHidden = false;
                    }
                    
                    if (!navigationController.visibleViewController.navigationItem.leftItemsSupplementBackButton) {
                        if (navigationController.visibleViewController.navigationItem.leftBarButtonItems) {
                            NSArray *leftBarButtonItems = navigationController.visibleViewController.navigationItem.leftBarButtonItems;
                            [invocations addObject:jz_invocation_create(navigationController.visibleViewController.navigationItem, @selector(setLeftBarButtonItems:), &leftBarButtonItems)];
                            navigationController.visibleViewController.navigationItem.leftBarButtonItems = nil;
                        } else if (navigationController.visibleViewController.navigationItem.leftBarButtonItem) {
                            UIBarButtonItem *leftBarButtonItem = navigationController.visibleViewController.navigationItem.leftBarButtonItem;
                            [invocations addObject:jz_invocation_create(navigationController.visibleViewController.navigationItem, @selector(setLeftBarButtonItem:), &leftBarButtonItem)];
                            navigationController.visibleViewController.navigationItem.leftBarButtonItem = nil;
                        }
                    }
                    
                    if (navigationController.visibleViewController.navigationItem.hidesBackButton) {
                        BOOL hidesBackButton = true;
                        [invocations addObject:jz_invocation_create(navigationController.visibleViewController.navigationItem, @selector(setHidesBackButton:), &hidesBackButton)];
                        navigationController.visibleViewController.navigationItem.hidesBackButton = false;
                    }
                    
                    BOOL shouldReceiveTouch = _originalShouldReceiveTouchIMP(navigationTransition, sel_shouldReceiveTouch, gestureRecognizer, touch);
                    
                    [invocations makeObjectsPerformSelector:@selector(invoke)];
                    
                    return shouldReceiveTouch;
                }));
            }
            {
                SEL sel_updateInteractiveTransition = @selector(updateInteractiveTransition:);
                jz_class_reImplementation(cls_UINavigationInteractiveTransition, sel_updateInteractiveTransition, [cls_JZNavigationInteractiveTransition instanceMethodForSelector:sel_updateInteractiveTransition]);
            }
            {
                SEL sel_cancelInteractiveTransition = @selector(cancelInteractiveTransition);
                jz_class_reImplementation(cls_UINavigationInteractiveTransition, sel_cancelInteractiveTransition, [cls_JZNavigationInteractiveTransition instanceMethodForSelector:sel_cancelInteractiveTransition]);
            }
            {
                SEL sel_finishInteractiveTransition = @selector(finishInteractiveTransition);
                jz_class_reImplementation(cls_UINavigationInteractiveTransition, sel_finishInteractiveTransition, [cls_JZNavigationInteractiveTransition instanceMethodForSelector:sel_finishInteractiveTransition]);
            }
        }
        
        {
            jz_class_reImplementation([UINavigationBar class], NSSelectorFromString(@"_popForTouchAtPoint:"), imp_implementationWithBlock(^(UINavigationBar *navigationBar) {
                [(UINavigationController *)navigationBar.delegate popViewControllerAnimated:navigationBar.jz_transitionAnimated];
            }));
        }
        
        {
            jz_method_swizzling([UINavigationBar class], @selector(sizeThatFits:), @selector(jz_sizeThatFits:));
        }
        
        {
            jz_method_swizzling([UIToolbar class], @selector(sizeThatFits:), @selector(jz_sizeThatFits:));
        }
        
        {
            jz_method_swizzling([UINavigationController class], @selector(pushViewController:animated:),@selector(jz_pushViewController:animated:));
        }
        
        {
            jz_method_swizzling([UINavigationController class], @selector(popViewControllerAnimated:), @selector(jz_popViewControllerAnimated:));
        }
        
        {
            jz_method_swizzling([UINavigationController class], @selector(popToViewController:animated:), @selector(jz_popToViewController:animated:));
        }
        
        {
            jz_method_swizzling([UINavigationController class], @selector(popToRootViewControllerAnimated:), @selector(jz_popToRootViewControllerAnimated:));
        }
        
        {
            jz_method_swizzling([UINavigationController class], @selector(setViewControllers:animated:), @selector(jz_setViewControllers:animated:));
        }
        
        {
            jz_method_swizzling([UINavigationController class], NSSelectorFromString(@"navigationTransitionView:didEndTransition:fromView:toView:"),@selector(jz_navigationTransitionView:didEndTransition:fromView:toView:));
        }
        
    });
}

- (void)jz_handleNavigationTransitionAnimated:(BOOL)animated fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController transitionBlock:(dispatch_block_t)transitionBlock {
    
    self.navigationBar.jz_transitionAnimated = animated;
    
    self.jz_previousVisibleViewController = fromViewController;
    
    UIView *snapshotView = [UIApplication sharedApplication].keyWindow;
    
    if (objc_getAssociatedObject(self, @selector(jz_navigationBarTransitionStyle))) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.navigationBar.bounds.size.width, self.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + 0.1), NO, 0.0);
        
        if (!self.navigationBarHidden) {
            [snapshotView drawViewHierarchyInRect:snapshotView.bounds afterScreenUpdates:false];
        }
    }
    
    transitionBlock();
    
    JZNavigationBarTransitionStyle navigationBarTransitionStyle = self.jz_navigationBarTransitionStyle;
    
    if ( ![[self valueForKey:@"isBuiltinTransition"] boolValue] || !self.navigationBar.isTranslucent || navigationBarTransitionStyle == JZNavigationBarTransitionStyleSystem ) {
        
        UIGraphicsEndImageContext();
        
        if (self.jz_isInteractiveTransition && self.navigationBar.hidden && ![toViewController jz_wantsNavigationBarVisibleWithNavigationController:self]) {
            [self setNavigationBarHidden:false animated:animated];
            self.navigationBar.hidden = true;
        } else {
            [self setNavigationBarHidden:![toViewController jz_wantsNavigationBarVisibleWithNavigationController:self] animated:animated];
        }
        
        if (![self jz_isInteractiveTransition]) {
            
            if ([fromViewController jz_navigationBarBackgroundAlphaWithNavigationController:self] != [toViewController jz_navigationBarBackgroundAlphaWithNavigationController:self]) {
                [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration : 0.f animations:^{
                    [self setJz_navigationBarBackgroundAlpha:[toViewController jz_navigationBarBackgroundAlphaWithNavigationController:self]];
                }];
            }
            
            if ([fromViewController jz_navigationBarTintColorWithNavigationController:self] != [toViewController jz_navigationBarTintColorWithNavigationController:self]) {
                
                if (!self.jz_navigationBarTintColor) {
                    self.jz_navigationBarTintColor = [UIColor colorWithWhite:self.navigationBar.barStyle == UIBarStyleDefault alpha:1.0];
                }
                
                UIColor *_toColor = toViewController.jz_navigationBarTintColor;
                if (!_toColor) {
                    _toColor = [UIColor colorWithWhite:self.navigationBar.barStyle == UIBarStyleDefault alpha:1.0];
                }
                
                [UIView animateWithDuration:animated ? UINavigationControllerHideShowBarDuration: 0.f animations:^{
                    [self setJz_navigationBarTintColor:_toColor];
                } completion:^(BOOL finished) {
                    if (!toViewController.jz_navigationBarTintColor) {
                        [self setJz_navigationBarTintColor:toViewController.jz_navigationBarTintColor];
                    }
                }];
                
            }
            
        }
        
        return;
    }
    
    static CALayer * (^_snapshotLayerWithImage) (UIImage *snapshotImage) = ^CALayer *(UIImage *snapshotImage) {
        CALayer *snapshotLayer = [CALayer layer];
        snapshotLayer.name = kSnapshotLayerNameForTransition;
        snapshotLayer.contents = (__bridge id _Nullable)snapshotImage.CGImage;
        snapshotLayer.contentsScale = snapshotImage.scale;
        snapshotLayer.frame = (CGRect){CGPointZero, snapshotImage.size};
        return snapshotLayer;
    };
    
    if (!self.navigationBarHidden && navigationBarTransitionStyle == JZNavigationBarTransitionStyleDoppelganger) {
        [fromViewController.view.layer addSublayer:_snapshotLayerWithImage(UIGraphicsGetImageFromCurrentImageContext())];
    }
    
    self.navigationBarHidden = ![toViewController jz_wantsNavigationBarVisibleWithNavigationController:self];
    self.jz_navigationBarTintColor = [toViewController jz_navigationBarTintColorWithNavigationController:self];
    self.jz_navigationBarBackgroundAlpha = [toViewController jz_navigationBarBackgroundAlphaWithNavigationController:self];
    
    [snapshotView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (!self.jz_didEndNavigationTransitionBlock) {
            UIGraphicsEndImageContext();
            return;
        }
        
        if (!self.navigationBarHidden) {
            
            CALayer *snapshotLayer = _snapshotLayerWithImage(UIGraphicsGetImageFromCurrentImageContext());
            
            if (navigationBarTransitionStyle == JZNavigationBarTransitionStyleDoppelganger) {
                [toViewController.view.layer addSublayer:snapshotLayer];
            } else {
                [self.navigationBar.superview.layer addSublayer:snapshotLayer];
            }
            
        }
        
        UIGraphicsEndImageContext();
        
    });
    
    CGFloat navigationBarAlpha = self.navigationBar.alpha;
    
    self.navigationBar.alpha = 0.f;
    
    __weak typeof(self) weakSelf = self;
    
    self.jz_didEndNavigationTransitionBlock = ^{
        
        weakSelf.jz_didEndNavigationTransitionBlock = NULL;
        
        if (![toViewController isEqual:weakSelf.visibleViewController]) {
            UIViewController *toViewController = weakSelf.visibleViewController;
            weakSelf.navigationBarHidden = ![toViewController jz_wantsNavigationBarVisibleWithNavigationController:weakSelf];
            weakSelf.jz_navigationBarTintColor = toViewController.jz_navigationBarTintColor;
            weakSelf.jz_navigationBarBackgroundAlpha = [toViewController jz_navigationBarBackgroundAlphaWithNavigationController:weakSelf];
        }
        
        weakSelf.navigationBar.alpha = navigationBarAlpha;
        
        NSPredicate *getSubSnapshotLayerPredicate = [NSPredicate predicateWithFormat:@"name == %@", kSnapshotLayerNameForTransition];
        NSArray <CALayer *> *result = nil;
        if (navigationBarTransitionStyle == JZNavigationBarTransitionStyleDoppelganger) {
            result = [fromViewController.view.layer.sublayers filteredArrayUsingPredicate:getSubSnapshotLayerPredicate];
            [result makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
            result = [toViewController.view.layer.sublayers filteredArrayUsingPredicate:getSubSnapshotLayerPredicate];
            [result makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        } else {
            result = [weakSelf.navigationBar.superview.layer.sublayers filteredArrayUsingPredicate:getSubSnapshotLayerPredicate];
            [result makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        }
        
    };
}

- (void)jz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self.jz_operation = UINavigationControllerOperationPush;
    self._jz_navigationTransitionFinished = completion;
    
    [self jz_handleNavigationTransitionAnimated:animated fromViewController:self.visibleViewController toViewController:viewController transitionBlock:^{
        [self jz_pushViewController:viewController animated:animated];
    }];
    
}

- (void)jz_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    NSArray *oldViewControllers = self.viewControllers;
    UINavigationControllerOperation operation = UINavigationControllerOperationNone;
    if (viewControllers.count > oldViewControllers.count) {
        operation = UINavigationControllerOperationPush;
    } else if (viewControllers.count < oldViewControllers.count) {
        operation = UINavigationControllerOperationPop;
    }
    
    self.jz_operation = operation;
    self._jz_navigationTransitionFinished = completion;
    
    [self jz_handleNavigationTransitionAnimated:animated fromViewController:oldViewControllers.lastObject toViewController:viewControllers.lastObject transitionBlock:^{
        [self jz_setViewControllers:viewControllers animated:animated];
    }];
    
}

- (UIViewController *)jz_popViewControllerAnimated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self.jz_operation = UINavigationControllerOperationPop;
    self._jz_navigationTransitionFinished = completion;
    
    UIViewController *fromViewController = [self visibleViewController];
    [self jz_handleNavigationTransitionAnimated:animated fromViewController:fromViewController toViewController:[fromViewController jz_previousViewController] transitionBlock:^{
        [self jz_popViewControllerAnimated:animated];
    }];
    
    return fromViewController;
}

- (NSArray *)jz_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self.jz_operation = UINavigationControllerOperationPop;
    self._jz_navigationTransitionFinished = completion;
    
    __block NSArray *popedViewControllers = nil;
    [self jz_handleNavigationTransitionAnimated:animated fromViewController:self.visibleViewController toViewController:viewController transitionBlock:^{
        popedViewControllers = [self jz_popToViewController:viewController animated:animated];
    }];
    
    return popedViewControllers;
}

- (NSArray *)jz_popToRootViewControllerAnimated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self.jz_operation = UINavigationControllerOperationPop;
    self._jz_navigationTransitionFinished = completion;
    
    __block NSArray *popedViewControllers = nil;
    [self jz_handleNavigationTransitionAnimated:animated fromViewController:self.visibleViewController toViewController:self.viewControllers.firstObject transitionBlock:^{
        popedViewControllers = [self jz_popToRootViewControllerAnimated:animated];
    }];
    
    return popedViewControllers;
}

#pragma mark - private funcs

- (void)jz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self jz_pushViewController:viewController animated:animated completion:NULL];
}

- (void)jz_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated {
    [self jz_setViewControllers:viewControllers animated:animated completion:NULL];
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
    
    !self.jz_didEndNavigationTransitionBlock ?: self.jz_didEndNavigationTransitionBlock();
    
    self.jz_operation = UINavigationControllerOperationNone;
    
    !self._jz_navigationTransitionFinished ?: self._jz_navigationTransitionFinished(self, YES);
    
    self._jz_navigationTransitionFinished = NULL;
    
    [self jz_previousVisibleViewController];
}

#pragma mark - setters

- (void)setJz_navigationBarTransitionStyle:(JZNavigationBarTransitionStyle)jz_navigationBarTransitionStyle {
    objc_setAssociatedObject(self, @selector(jz_navigationBarTransitionStyle), @(jz_navigationBarTransitionStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setJz_navigationBarTintColorView:(UIView *)jz_navigationBarTintColorView {
    objc_setAssociatedObject(self, @selector(jz_navigationBarTintColorView), jz_navigationBarTintColorView ? [_JZValue valueWithWeakObject:jz_navigationBarTintColorView] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJz_navigationBarTintColor:(UIColor *)jz_navigationBarTintColor {
    self.navigationBar.barTintColor = jz_navigationBarTintColor;
}

- (void)setJz_fullScreenInteractivePopGestureEnabled:(BOOL)jz_fullScreenInteractivePopGestureEnabled {
    if (!self.jz_fullScreenInteractivePopGestureRecognizer) {
        NSMutableArray *_interactiveTargets = jz_getProperty(self.interactivePopGestureRecognizer, @"_targets");
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:jz_getProperty(_interactiveTargets.firstObject, @"_target") action:JZ_sel_handleNavigationTransition];
        [panGestureRecognizer setValue:@NO forKey:@"canPanVertically"];
        self._jz_interactiveTransition = [[_JZNavigationInteractiveTransition alloc] initWithNavigationController:self];
        panGestureRecognizer.delegate = self._jz_interactiveTransition;
        [[self.interactivePopGestureRecognizer view] addGestureRecognizer:panGestureRecognizer];
        self.jz_fullScreenInteractivePopGestureRecognizer = panGestureRecognizer;
    }
    self.jz_fullScreenInteractivePopGestureRecognizer.enabled = jz_fullScreenInteractivePopGestureEnabled;
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

- (void)set_jz_navigationTransitionFinished:(_jz_navigation_block_t)_jz_navigationTransitionFinished {
    objc_setAssociatedObject(self, @selector(_jz_navigationTransitionFinished), _jz_navigationTransitionFinished, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)jz_setInteractivePopGestureRecognizerCompletion:(_jz_navigation_block_t)jz_interactivePopGestureRecognizerCompletion {
    objc_setAssociatedObject(self, @selector(jz_interactivePopGestureRecognizerCompletion), jz_interactivePopGestureRecognizerCompletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setJz_operation:(UINavigationControllerOperation)jz_operation {
    objc_setAssociatedObject(self, @selector(jz_operation), @(jz_operation), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setJz_previousVisibleViewController:(UIViewController * _Nullable)jz_previousVisibleViewController {
    objc_setAssociatedObject(self, @selector(jz_previousVisibleViewController), jz_previousVisibleViewController ? [_JZValue valueWithWeakObject:jz_previousVisibleViewController] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)set_jz_interactiveTransition:(_JZNavigationInteractiveTransition *)_jz_interactiveTransition {
    objc_setAssociatedObject(self, @selector(_jz_interactiveTransition), _jz_interactiveTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJz_fullScreenInteractivePopGestureRecognizer:(UIPanGestureRecognizer *)jz_fullScreenInteractivePopGestureRecognizer {
    objc_setAssociatedObject(self, @selector(jz_fullScreenInteractivePopGestureRecognizer), jz_fullScreenInteractivePopGestureRecognizer ? [_JZValue valueWithWeakObject:jz_fullScreenInteractivePopGestureRecognizer] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJz_didEndNavigationTransitionBlock:(dispatch_block_t)jz_didEndNavigationTransitionBlock {
    objc_setAssociatedObject(self, @selector(jz_didEndNavigationTransitionBlock), jz_didEndNavigationTransitionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - getters

- (dispatch_block_t)jz_didEndNavigationTransitionBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (JZNavigationBarTransitionStyle)jz_navigationBarTransitionStyle {
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
}

- (UIView *)jz_navigationBarTintColorView {
    id weakObject = [objc_getAssociatedObject(self, _cmd) weakObjectValue];
    if (!weakObject) {
        self.jz_navigationBarTintColorView = nil;
    }
    return weakObject;
}

- (UIPanGestureRecognizer *)jz_fullScreenInteractivePopGestureRecognizer {
    id _fullScreenInteractivePopGestureRecognizer = [objc_getAssociatedObject(self, _cmd) weakObjectValue];
    if (!_fullScreenInteractivePopGestureRecognizer) {
        self.jz_fullScreenInteractivePopGestureRecognizer = nil;
    }
    return _fullScreenInteractivePopGestureRecognizer;
}

- (_JZNavigationInteractiveTransition *)_jz_interactiveTransition {
    return objc_getAssociatedObject(self, _cmd);
}

- (UIViewController *)jz_previousVisibleViewController {
    id _previousVisibleViewController = [objc_getAssociatedObject(self, _cmd) weakObjectValue];
    if (!_previousVisibleViewController) {
        self.jz_previousVisibleViewController = nil;
    }
    return _previousVisibleViewController;
}

- (UIColor *)jz_navigationBarTintColor {
    return self.navigationBar.barTintColor;
}

- (UINavigationControllerOperation)jz_operation {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (CGFloat)jz_navigationBarBackgroundAlpha {
    return [[self.navigationBar jz_backgroundView] alpha];
}

- (CGFloat)jz_toolbarBackgroundAlpha {
    return [[self.toolbar jz_backgroundView] alpha];
}

- (BOOL)jz_fullScreenInteractivePopGestureEnabled {
    return self.jz_fullScreenInteractivePopGestureRecognizer.enabled;
}

- (_jz_navigation_block_t)_jz_navigationTransitionFinished {
    return objc_getAssociatedObject(self, _cmd);
}

- (_jz_navigation_block_t)jz_interactivePopGestureRecognizerCompletion {
    return objc_getAssociatedObject(self, _cmd);
}

- (CGSize)jz_navigationBarSize {
    return [self.navigationBar jz_size];
}

- (CGSize)jz_toolbarSize {
    return [self.toolbar jz_size];
}

- (BOOL)jz_isInteractiveTransition {
    return [jz_getProperty(self, @"isInteractiveTransition") boolValue];
}

- (BOOL)jz_isTransitioning {
    return [jz_getProperty(self, @"_isTransitioning") boolValue];
}

- (UIViewController *)jz_previousViewControllerForViewController:(UIViewController *)viewController {
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    
    if (!index || index == NSNotFound) return nil;
    
    return self.viewControllers[index - 1];
}

@end
