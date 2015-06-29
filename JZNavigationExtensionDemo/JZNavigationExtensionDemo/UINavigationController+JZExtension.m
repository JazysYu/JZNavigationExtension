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

@implementation UIToolbar (JZExtension)

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize = [super sizeThatFits:size];
    return CGSizeMake(newSize.width == 320.f ? [UIScreen mainScreen].bounds.size.width : newSize.width, newSize.height);
}

@end

@implementation UINavigationBar (JZExtension)

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize = [super sizeThatFits:size];
    return CGSizeMake(newSize.width == 320.f ? [UIScreen mainScreen].bounds.size.width : newSize.width, newSize.height);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([[self valueForKey:@"_backgroundView"] alpha] < 1.0f) {
        return CGRectContainsPoint(CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44), point);
    } else {
        return [super pointInside:point withEvent:event];
    }
}

@end

@interface UINavigationController ()
@property (nonatomic, copy) void (^_push_pop_Finished)(BOOL);
@end

@implementation UINavigationController (JZExtension)
static const void *__push_pop_Finished = &__push_pop_Finished;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /**
         *  rewrite the implementation for interactivePopGestureRecognizer's delegate.
         */
        {
            Class _UINavigationInteractiveTransition = NSClassFromString(@"_UINavigationInteractiveTransition");

            {
                Method gestureShouldReceiveTouch = class_getInstanceMethod(_UINavigationInteractiveTransition, @selector(gestureRecognizer:shouldReceiveTouch:));
                method_setImplementation(gestureShouldReceiveTouch, imp_implementationWithBlock(^(UIPercentDrivenInteractiveTransition *navTransition,UIGestureRecognizer *gestureRecognizer, UITouch *touch){
                    UINavigationController *navigationController = (UINavigationController *)[navTransition valueForKey:@"__parent"];
                    return navigationController.viewControllers.count != 1 && ![[navigationController valueForKey:@"_isTransitioning"] boolValue];;
                }));
            }
            
            {
                Method gestureShouldSimultaneouslyGesture = class_getInstanceMethod(_UINavigationInteractiveTransition, NSSelectorFromString(@"_gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer:"));
                method_setImplementation(gestureShouldSimultaneouslyGesture, imp_implementationWithBlock(^{
                    return NO;
                }));
            
            }
        }
        
        {
            void (^__method_swizzling)(SEL, SEL) = ^(SEL sel, SEL _sel) {
                Method  method = class_getInstanceMethod(self, sel);
                Method _method = class_getInstanceMethod(self, _sel);
                method_exchangeImplementations(method, _method);
            };
            
            {
                __method_swizzling(@selector(pushViewController:animated:),@selector(_pushViewController:animated:));
            }
            
            {
                __method_swizzling(@selector(popViewControllerAnimated:), @selector(_popViewControllerAnimated:));
            }
            
            {
                __method_swizzling(@selector(popToViewController:animated:), @selector(_popToViewController:animated:));
            }
            
            {
                __method_swizzling(@selector(popToRootViewControllerAnimated:), @selector(_popToRootViewControllerAnimated:));
            }
            
            {
                __method_swizzling(NSSelectorFromString(@"navigationTransitionView:didEndTransition:fromView:toView:"),@selector(_navigationTransitionView:didEndTransition:fromView:toView:));
            }
        }
    });
}

#pragma mark - func

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

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL))completion {
    self._push_pop_Finished = completion;
    [self _pushViewController:viewController animated:animated];
    [self setNavigationBarHidden:viewController.hidesNavigationBarWhenPushed animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL))completion {
    self._push_pop_Finished = completion;
    UIViewController *viewController = [self _popViewControllerAnimated:animated];
    [self setNavigationBarHidden:[self visibleViewController].hidesNavigationBarWhenPushed animated:animated];
    return viewController;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    self._push_pop_Finished = completion;
    NSArray *popedViewControllers = [self _popToViewController:viewController animated:animated];
    [self setNavigationBarHidden:[self visibleViewController].hidesNavigationBarWhenPushed animated:animated];
    return popedViewControllers;
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    self._push_pop_Finished = completion;
    NSArray *popedViewControllers = [self _popToRootViewControllerAnimated:animated];
    [self setNavigationBarHidden:[self visibleViewController].hidesNavigationBarWhenPushed animated:animated];
    return popedViewControllers;
}

- (void)_navigationTransitionView:(id)arg1 didEndTransition:(int)arg2 fromView:(id)arg3 toView:(id)arg4 {
    [self _navigationTransitionView:arg1 didEndTransition:arg2 fromView:arg3 toView:arg4];
    !self._push_pop_Finished ?: self._push_pop_Finished(YES);
}

#pragma mark - setters

- (void)setFullScreenInteractivePopGestureRecognizer:(BOOL)fullScreenInteractivePopGestureRecognizer {
    if (fullScreenInteractivePopGestureRecognizer) {
        if ([self.interactivePopGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]]) return;
        object_setClass(self.interactivePopGestureRecognizer, [UIPanGestureRecognizer class]);
    } else {
        if ([self.interactivePopGestureRecognizer isMemberOfClass:[UIScreenEdgePanGestureRecognizer class]]) return;
        object_setClass(self.interactivePopGestureRecognizer, [UIScreenEdgePanGestureRecognizer class]);
    }
}

- (void)setToolbarBackgroundAlpha:(CGFloat)toolbarBackgroundAlpha {
    [[self.toolbar valueForKey:@"_shadowView"] setAlpha:toolbarBackgroundAlpha];
    [[self.toolbar valueForKey:@"_backgroundView"] setAlpha:toolbarBackgroundAlpha];
}

- (void)setNavigationBarBackgroundAlpha:(CGFloat)navigationBarBackgroundAlpha {
    [[self.navigationBar valueForKey:@"_backgroundView"] setAlpha:navigationBarBackgroundAlpha];
}

- (void)setNavigationBarSize:(CGSize)navigationBarSize {
    CGRect rect = self.navigationBar.frame;
    rect.size = navigationBarSize;
    self.navigationBar.frame = rect;
}

- (void)setToolbarSize:(CGSize)toolbarSize {
    CGRect rect = self.toolbar.frame;
    rect.size = toolbarSize;
    self.toolbar.frame = rect;
}

- (void)set_push_pop_Finished:(void (^)(BOOL))_push_pop_Finished {
    objc_setAssociatedObject(self, __push_pop_Finished, _push_pop_Finished, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - getters

- (CGFloat)navigationBarBackgroundAlpha {
    return [[self.navigationBar valueForKey:@"_backgroundView"] alpha];
}

- (CGFloat)toolbarBackgroundAlpha {
    return [[self.navigationBar valueForKey:@"_backgroundView"] alpha];
}

- (BOOL)fullScreenInteractivePopGestureRecognizer {
    return [self.interactivePopGestureRecognizer isMemberOfClass:[UIPanGestureRecognizer class]];
}

- (void (^)(BOOL))_push_pop_Finished {
    return objc_getAssociatedObject(self, __push_pop_Finished);
}

- (UIViewController *)previousViewControllerForViewController:(UIViewController *)viewController {
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    
    if (!index) return nil;
    
    return self.viewControllers[index - 1];
}

@end

@implementation UIViewController (JZExtension)
static const void *_hidesNavigationBarWhenPushed = &_hidesNavigationBarWhenPushed;

- (void)setHidesNavigationBarWhenPushed:(BOOL)hidesNavigationBarWhenPushed {
    objc_setAssociatedObject(self, _hidesNavigationBarWhenPushed, @(hidesNavigationBarWhenPushed), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)hidesNavigationBarWhenPushed {
    return [objc_getAssociatedObject(self, _hidesNavigationBarWhenPushed) boolValue];
}

@end
