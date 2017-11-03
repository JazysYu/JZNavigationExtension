//
//  _JZ-objc-internal.h
//
//  Created by Jazys on 3/11/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#ifndef _JZ_objc_internal_h
#define _JZ_objc_internal_h

#import <objc/runtime.h>

#define jz_getProperty(objc,key) [objc valueForKey:key]

#define JZNavigationBarHeight 44.f

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wnullability-completeness"

extern __attribute__((visibility ("default"))) BOOL jz_isVersionBelow9_0;
@class _JZNavigationInteractiveTransition, _JZNavigationDelegating;
typedef void(^_jz_navigation_block_t)(UINavigationController *navigationController, BOOL finished);
@interface UINavigationController (_JZExtension) <UINavigationBarDelegate>
@property (nonatomic, copy) dispatch_block_t jz_navigationTransitionStyleObserving;
@property (nonatomic, copy, setter=jz_setInteractivePopGestureRecognizerCompletion:) _jz_navigation_block_t jz_interactivePopGestureRecognizerCompletion;
@property (nonatomic, copy) _jz_navigation_block_t jz_navigationTransitionCompletion;
@property (nonatomic, strong) _JZNavigationInteractiveTransition *_jz_interactiveTransition;
@property (nonatomic, weak, readwrite) UIView *jz_navigationBarTintColorView;
@property (nonatomic) _JZNavigationDelegating *jz_navigationDelegate;
- (void)setJz_operation:(UINavigationControllerOperation)jz_operation;
- (void)setJz_previousVisibleViewController:(UIViewController * _Nullable)jz_previousVisibleViewController;
@end

@interface UIViewController (_JZExtension)
@property (nonatomic, assign, getter=jz_hasNavigationBarTintColorSetterBeenCalled) BOOL jz_navigationBarTintColorSetterBeenCalled;
- (CGFloat)jz_navigationBarBackgroundAlphaWithNavigationController:(UINavigationController *)navigationController;
- (UIColor *)jz_navigationBarTintColorWithNavigationController:(UINavigationController *)navigationController;
- (BOOL)jz_wantsNavigationBarVisibleWithNavigationController:(UINavigationController *)navigationController;
@end

@interface UINavigationBar (_JZExtension)
@property (nonatomic) BOOL jz_transitionAnimated;
@end

@protocol JZExtensionBarProtocol <NSObject>
@property (nonatomic, assign) CGSize jz_size;
- (UIView * _Nullable)jz_backgroundView;
- (CGSize)jz_sizeThatFits:(CGSize)size;
@end

#define JZExtensionBarImplementation \
- (CGSize)jz_sizeThatFits:(CGSize)size { \
CGSize newSize = [self jz_sizeThatFits:size]; \
return CGSizeMake(self.jz_size.width == 0.f ? newSize.width : self.jz_size.width, self.jz_size.height == 0.f ? newSize.height : self.jz_size.height); \
} \
- (void)setJz_size:(CGSize)size { \
objc_setAssociatedObject(self, @selector(jz_size), [NSValue valueWithCGSize:size], OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
[self sizeToFit]; \
} \
- (CGSize)jz_size { \
return [objc_getAssociatedObject(self, _cmd) CGSizeValue]; \
} \
- (UIView *)jz_backgroundView { \
return jz_getProperty(self, @"_backgroundView"); \
}

#define JZ_sel_handleNavigationTransition NSSelectorFromString(@"handleNavigationTransition:")
#define JZ_UINavigationInteractiveTransition NSClassFromString(@"_UINavigationInteractiveTransition")

#pragma clang diagnostic pop

#endif /* _JZ_objc_internal_h */
