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
#import "_JZNavigationDelegating.h"

@implementation UINavigationController (JZExtension)

void (^jz_method_swizzling)(Class, SEL, SEL) = ^(Class class, SEL originalSelector, SEL swizzledSelector) {
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    if (class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
};

__attribute__((constructor)) static void JZ_Inject(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jz_method_swizzling([UINavigationController class], @selector(setDelegate:), @selector(jz_setDelegate:));
        jz_method_swizzling([UINavigationController class], @selector(viewDidLoad), @selector(jz_viewDidLoad));
    });
}

- (void)jz_viewDidLoad {
    self.delegate = nil;
    [self.interactivePopGestureRecognizer setValue:@NO forKey:@"canPanVertically"];
    self.interactivePopGestureRecognizer.delegate = self.jz_navigationDelegate;
    [self jz_viewDidLoad];
}

- (void)jz_setDelegate:(NSObject <UINavigationControllerDelegate> *)delegate {
    
    if ([self.delegate isEqual:delegate]) {
        return;
    }
    
    NSString *_JZNavigationDelegatingTrigger = @"_JZNavigationDelegatingTrigger";
    
    if (![self.delegate isEqual:self.jz_navigationDelegate]) {
        [(NSObject *)self.delegate removeObserver:self forKeyPath:_JZNavigationDelegatingTrigger context:_cmd];
    }
    
    if (!delegate) {
        
        delegate = self.jz_navigationDelegate;
        
    } else {
        
        NSAssert([delegate isKindOfClass:[NSObject class]], @"Must inherit form NSObject");
        
        [delegate addObserver:self forKeyPath:_JZNavigationDelegatingTrigger options:NSKeyValueObservingOptionNew context:_cmd];
                
        void (^jz_replaceMethod)(Class, Class, SEL) = ^(Class cls1, Class cls2, SEL sel) {
            Method method = class_getInstanceMethod(cls1, sel);
            IMP imp = method_getImplementation(method);
            const char *types = method_getTypeEncoding(method);
            class_replaceMethod(cls2, sel, imp, types);
        };
        
        Class realClass = object_getClass(delegate);
        jz_replaceMethod([_JZNavigationDelegating class], realClass, @selector(navigationController:willShowViewController:animated:));
        jz_replaceMethod([_JZNavigationDelegating class], realClass, @selector(navigationController:didShowViewController:animated:));
        
    }
    
    [self jz_setDelegate:delegate];
    
}


- (void)jz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self.jz_navigationTransitionCompletion = completion;
    
    [self pushViewController:viewController animated:animated];
    
}

- (void)jz_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self.jz_navigationTransitionCompletion = completion;
    
    [self setViewControllers:viewControllers animated:animated];
    
}

- (UIViewController *)jz_popViewControllerAnimated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self.jz_navigationTransitionCompletion = completion;
    
    return [self popViewControllerAnimated:animated];
}

- (NSArray *)jz_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self.jz_navigationTransitionCompletion = completion;
    
    return [self popToViewController:viewController animated:animated];
}

- (NSArray *)jz_popToRootViewControllerAnimated:(BOOL)animated completion:(_jz_navigation_block_t)completion {
    
    self.jz_navigationTransitionCompletion = completion;
    
    return [self popToRootViewControllerAnimated:animated];
}

#pragma mark - setters

- (void)setJz_navigationBarTransitionStyle:(JZNavigationBarTransitionStyle)jz_navigationBarTransitionStyle {
    objc_setAssociatedObject(self, @selector(jz_navigationBarTransitionStyle), @(jz_navigationBarTransitionStyle), OBJC_ASSOCIATION_ASSIGN);
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

- (void)setJz_navigationTransitionCompletion:(_jz_navigation_block_t)jz_navigationTransitionCompletion {
    objc_setAssociatedObject(self, @selector(jz_navigationTransitionCompletion), jz_navigationTransitionCompletion, OBJC_ASSOCIATION_COPY_NONATOMIC);
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

- (void)setJz_navigationTransitionStyleObserving:(dispatch_block_t)jz_navigationTransitionStyleObserving {
    objc_setAssociatedObject(self, @selector(jz_navigationTransitionStyleObserving), jz_navigationTransitionStyleObserving, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setJz_fullScreenInteractivePopGestureEnabled:(BOOL)jz_fullScreenInteractivePopGestureEnabled {
    object_setClass(self.interactivePopGestureRecognizer, jz_fullScreenInteractivePopGestureEnabled ? [UIPanGestureRecognizer class] : [UIScreenEdgePanGestureRecognizer class]);
}

- (void)setJz_navigationDelegate:(_JZNavigationDelegating *)jz_navigationDelegate {
    objc_setAssociatedObject(self, @selector(jz_navigationDelegate), jz_navigationDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getters

- (dispatch_block_t)jz_navigationTransitionStyleObserving {
    return objc_getAssociatedObject(self, _cmd);
}

- (JZNavigationBarTransitionStyle)jz_navigationBarTransitionStyle {
    return [objc_getAssociatedObject(self, _cmd) unsignedIntegerValue];
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
    return [self.interactivePopGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]];
}

- (_jz_navigation_block_t)jz_navigationTransitionCompletion {
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
    _JZNavigationDelegating *jz_navigationDelegate = objc_getAssociatedObject(self, _cmd);
    if (!jz_navigationDelegate) {
        jz_navigationDelegate = [[_JZNavigationDelegating alloc] initWithNavigationController:self];
        self.jz_navigationDelegate = jz_navigationDelegate;
    }
    return jz_navigationDelegate;
}

@end
