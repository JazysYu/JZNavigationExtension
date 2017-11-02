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

void (^jz_method_swizzling)(Class, SEL, Class, SEL) = ^(Class cls1, SEL sel1, Class cls2, SEL sel2) {
    Method method1 = class_getInstanceMethod(cls1, sel1);
    Method method2 = class_getInstanceMethod(cls2, sel2);
    method_exchangeImplementations(method1, method2);
};

void (^jz_sel_method_swizzling)(Class, Class, SEL) = ^(Class cls1, Class cls2, SEL sel) {
    jz_method_swizzling(cls1, sel, cls2, sel);
};

void (^jz_class_method_swizzling)(Class, SEL, SEL) = ^(Class cls, SEL sel1, SEL sel2) {
    jz_method_swizzling(cls, sel1, cls, sel2);
};

__attribute__((constructor)) static void JZ_Inject(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [_JZNavigationDelegating setImp_willShowViewController:[NSMethodSignature instanceMethodForSelector:@selector(navigationController:willShowViewController:animated:)]];
//        [_JZNavigationDelegating setImp_didShowViewController:[NSMethodSignature instanceMethodForSelector:@selector(navigationController:didShowViewController:animated:)]];
        jz_class_method_swizzling([UINavigationController class], @selector(setDelegate:), @selector(jz_setDelegate:));
        jz_class_method_swizzling([UINavigationController class], @selector(interactivePopGestureRecognizer), @selector(jz_interactivePopGestureRecognizer));
    });
}

- (void)jz_setDelegate:(id<UINavigationControllerDelegate>)delegate {
    
    if (!delegate) {
        
        delegate = [[_JZNavigationDelegating alloc] init];
        self.jz_navigationDelegate = delegate;
        
    } else if (![delegate isKindOfClass:[_JZNavigationDelegating class]]) {
        
        Class superClass = object_getClass(delegate);
        
        const char *jz_class_name = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([_JZNavigationDelegating class]),NSStringFromClass(superClass)].UTF8String;
        
        Class JZNavigationDelegating = objc_allocateClassPair(superClass, jz_class_name, 0);
        
        if (JZNavigationDelegating) {
            
            void (^jz_replaceMethod)(Class, Class, SEL) = ^(Class cls1, Class cls2, SEL sel) {
                Method method = class_getInstanceMethod(cls1, sel);
                IMP imp = method_getImplementation(method);
                const char *types = method_getTypeEncoding(method);
                class_replaceMethod(cls2, sel, imp, types);
            };
            
            jz_replaceMethod([_JZNavigationDelegating class], JZNavigationDelegating, @selector(navigationController:willShowViewController:animated:));
            jz_replaceMethod([_JZNavigationDelegating class], JZNavigationDelegating, @selector(navigationController:didShowViewController:animated:));
            //        jz_replaceMethod(@selector(navigationControllerSupportedInterfaceOrientations:));
            //        jz_replaceMethod(@selector(navigationControllerPreferredInterfaceOrientationForPresentation:));
            //        jz_replaceMethod(@selector(navigationController:interactionControllerForAnimationController:));
            //        jz_replaceMethod(@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:));
            
            objc_registerClassPair(JZNavigationDelegating);
            
            object_setClass(delegate, JZNavigationDelegating);
            
        }
        
    }
    
    [self jz_setDelegate:delegate];
    
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

- (void)setJz_navigationDelegate:(_JZNavigationDelegating *)jz_navigationDelegate {
    objc_setAssociatedObject(self, @selector(jz_navigationDelegate), jz_navigationDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

- (_JZNavigationDelegating *)jz_navigationDelegate {
    return objc_getAssociatedObject(self, _cmd);
}

@end
