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
#import "_JZNavigationDelegating.h"

BOOL jz_isVersionBelow9_0 = false;

@implementation UINavigationController (JZExtension)

__attribute__((constructor)) static void JZ_Inject(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void (^jz_method_swizzling)(Class, SEL, SEL) = ^(Class cls, SEL sel, SEL _sel) {
            Method  method = class_getInstanceMethod(cls, sel);
            Method _method = class_getInstanceMethod(cls, _sel);
            method_exchangeImplementations(method, _method);
        };
        
        jz_method_swizzling([UINavigationController class], @selector(setDelegate:), @selector(jz_setDelegate:));
        jz_method_swizzling([UINavigationController class], @selector(interactivePopGestureRecognizer), @selector(jz_interactivePopGestureRecognizer));
        
        
//        void (^jz_class_reImplementation)(Class, SEL, IMP) = ^(Class cls, SEL sel, IMP imp) {
//            Method method = class_getInstanceMethod(cls, sel);
//            if (!class_addMethod(cls, sel, imp, method_getTypeEncoding(method))) {
//                method_setImplementation(method, imp);
//            }
//        };
        
        
//        {
//            Class cls_UINavigationInteractiveTransition = JZ_UINavigationInteractiveTransition;
//            Class cls_JZNavigationInteractiveTransition = [_JZNavigationInteractiveTransition class];
//            {
//                static NSInvocation *(^jz_invocation_create)(id, SEL, void *) = ^NSInvocation *(id target, SEL selector, void *argument){
//                    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[target methodSignatureForSelector:selector]];
//                    [invocation setTarget:target];
//                    [invocation setSelector:selector];
//                    [invocation setArgument:argument atIndex:2];
//                    [invocation retainArguments];
//                    return invocation;
//                };
//
//                SEL sel_shouldReceiveTouch = @selector(gestureRecognizer:shouldReceiveTouch:);
//
//                BOOL (*_originalShouldReceiveTouchIMP)(id, SEL, id, id) = (void *)[cls_UINavigationInteractiveTransition instanceMethodForSelector:sel_shouldReceiveTouch];
//
//                Method method_shouldReceiveTouch = class_getInstanceMethod(cls_UINavigationInteractiveTransition, sel_shouldReceiveTouch);
//                method_setImplementation(method_shouldReceiveTouch, imp_implementationWithBlock(^BOOL(id navigationTransition, id gestureRecognizer, id touch) {
//
//                    UINavigationController *navigationController = [navigationTransition valueForKey:@"__parent"];
//
//                    NSMutableArray<NSInvocation *> *invocations = [NSMutableArray array];
//
//                    if (navigationController.navigationBarHidden) {
//                        BOOL navigationBarHidden = true;
//                        [invocations addObject:jz_invocation_create(navigationController, @selector(setNavigationBarHidden:), &navigationBarHidden)];
//                        navigationController.navigationBarHidden = false;
//                    }
//
//                    if (!navigationController.visibleViewController.navigationItem.leftItemsSupplementBackButton) {
//                        if (navigationController.visibleViewController.navigationItem.leftBarButtonItems) {
//                            NSArray *leftBarButtonItems = navigationController.visibleViewController.navigationItem.leftBarButtonItems;
//                            [invocations addObject:jz_invocation_create(navigationController.visibleViewController.navigationItem, @selector(setLeftBarButtonItems:), &leftBarButtonItems)];
//                            navigationController.visibleViewController.navigationItem.leftBarButtonItems = nil;
//                        } else if (navigationController.visibleViewController.navigationItem.leftBarButtonItem) {
//                            UIBarButtonItem *leftBarButtonItem = navigationController.visibleViewController.navigationItem.leftBarButtonItem;
//                            [invocations addObject:jz_invocation_create(navigationController.visibleViewController.navigationItem, @selector(setLeftBarButtonItem:), &leftBarButtonItem)];
//                            navigationController.visibleViewController.navigationItem.leftBarButtonItem = nil;
//                        }
//                    }
//
//                    if (navigationController.visibleViewController.navigationItem.hidesBackButton) {
//                        BOOL hidesBackButton = true;
//                        [invocations addObject:jz_invocation_create(navigationController.visibleViewController.navigationItem, @selector(setHidesBackButton:), &hidesBackButton)];
//                        navigationController.visibleViewController.navigationItem.hidesBackButton = false;
//                    }
//
//                    BOOL shouldReceiveTouch = _originalShouldReceiveTouchIMP(navigationTransition, sel_shouldReceiveTouch, gestureRecognizer, touch);
//
//                    [invocations makeObjectsPerformSelector:@selector(invoke)];
//
//                    return shouldReceiveTouch;
//                }));
//            }
//        }
        
        
        
    });
}

- (void)jz_setDelegate:(id<UINavigationControllerDelegate>)delegate {
    
    if (!delegate || [delegate isKindOfClass:[_JZNavigationDelegating class]]) {
        goto setDelegate;
    }
    
    Class superClass = object_getClass(delegate);
    
    const char *jz_class_name = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([_JZNavigationDelegating class]),NSStringFromClass(superClass)].UTF8String;
    
    if (objc_getClass(jz_class_name)) {
        goto setDelegate;
    }
    
    Class JZNavigationDelegating = objc_allocateClassPair(superClass, jz_class_name, 0);
    
    if (JZNavigationDelegating) {
        
        void (^jz_replaceMethod)(SEL) = ^(SEL sel) {
            Method method = class_getInstanceMethod([_JZNavigationDelegating class], sel);
            IMP imp = method_getImplementation(method);
            const char *types = method_getTypeEncoding(method);
            class_replaceMethod(JZNavigationDelegating, sel, imp, types);
        };
        
        jz_replaceMethod(@selector(navigationController:willShowViewController:animated:));
        jz_replaceMethod(@selector(navigationController:didShowViewController:animated:));
//        jz_replaceMethod(@selector(navigationControllerSupportedInterfaceOrientations:));
//        jz_replaceMethod(@selector(navigationControllerPreferredInterfaceOrientationForPresentation:));
//        jz_replaceMethod(@selector(navigationController:interactionControllerForAnimationController:));
//        jz_replaceMethod(@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:));
        
        objc_registerClassPair(JZNavigationDelegating);
        
        object_setClass(delegate, JZNavigationDelegating);
        
    }
    
setDelegate:
    
    [self jz_setDelegate:delegate];
    
}
#warning here
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
}

- (void)jz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self._jz_navigationTransitionFinished = completion;
    
    [self pushViewController:viewController animated:animated];
    
}

- (void)jz_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self._jz_navigationTransitionFinished = completion;
    
    [self setViewControllers:viewControllers animated:animated];
    
}

- (UIViewController *)jz_popViewControllerAnimated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self._jz_navigationTransitionFinished = completion;
    
    return [self popViewControllerAnimated:animated];
}

- (NSArray *)jz_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self._jz_navigationTransitionFinished = completion;
    
    return [self popToViewController:viewController animated:animated];
}

- (NSArray *)jz_popToRootViewControllerAnimated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self._jz_navigationTransitionFinished = completion;
    
    return [self popToRootViewControllerAnimated:animated];
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

- (void)setJz_didEndNavigationTransitionBlock:(dispatch_block_t)jz_didEndNavigationTransitionBlock {
    objc_setAssociatedObject(self, @selector(jz_didEndNavigationTransitionBlock), jz_didEndNavigationTransitionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setJz_fullScreenInteractivePopGestureRecognizer:(UIPanGestureRecognizer *)jz_fullScreenInteractivePopGestureRecognizer {
    objc_setAssociatedObject(self, @selector(jz_fullScreenInteractivePopGestureRecognizer), jz_fullScreenInteractivePopGestureRecognizer ? [_JZValue valueWithWeakObject:jz_fullScreenInteractivePopGestureRecognizer] : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

#pragma mark - getters

- (UIGestureRecognizer *)jz_interactivePopGestureRecognizer {
    return self.jz_fullScreenInteractivePopGestureEnabled ? self.jz_fullScreenInteractivePopGestureRecognizer : [self jz_interactivePopGestureRecognizer];
}

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

- (UIViewController *)jz_previousViewControllerForViewController:(UIViewController *)viewController {
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    
    if (!index || index == NSNotFound) return nil;
    
    return self.viewControllers[index - 1];
}

@end
