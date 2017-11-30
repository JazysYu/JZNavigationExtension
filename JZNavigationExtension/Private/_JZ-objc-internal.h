//
//  _JZ-objc-internal.h
//
//  Created by Jazys on 3/11/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wnullability-completeness"

@class _JZNavigationDelegating;
typedef void(^_jz_navigation_block_t)(UINavigationController *navigationController, BOOL finished);
@interface UINavigationController (_JZExtension) <UINavigationBarDelegate>
@property (nonatomic, copy, setter=jz_setInteractivePopGestureRecognizerCompletion:) _jz_navigation_block_t jz_interactivePopGestureRecognizerCompletion;
@property (nonatomic, copy) _jz_navigation_block_t jz_navigationTransitionCompletion;
@property (nonatomic) _JZNavigationDelegating *jz_navigationDelegate;
- (void)setJz_previousVisibleViewController:(UIViewController * _Nullable)jz_previousVisibleViewController;
- (void)setJz_navigationBarBackgroundAlphaReal:(CGFloat)jz_navigationBarBackgroundAlpha;
- (void)setJz_operation:(UINavigationControllerOperation)jz_operation;
@end

@interface UIViewController (_JZExtension)
@property (nonatomic, assign, getter=jz_hasNavigationBarTintColorSetterBeenCalled) BOOL jz_navigationBarTintColorSetterBeenCalled;
- (BOOL)jz_navigationInteractivePopGestureEnabledWithNavigationController:(UINavigationController *)navigationController;
- (CGFloat)jz_navigationBarBackgroundAlphaWithNavigationController:(UINavigationController *)navigationController;
- (UIColor *)jz_navigationBarTintColorWithNavigationController:(UINavigationController *)navigationController;
- (BOOL)jz_navigationBarHiddenWithNavigationController:(UINavigationController *)navigationController;
@end

@interface NSNumber (JZExtension)
- (CGFloat)jz_CGFloatValue;
@end

@interface _JZValue : NSObject
+ (_JZValue *)valueWithWeakObject:(id)anObject;
@property (weak, readonly) id weakObjectValue;
@end

@protocol JZExtensionBarProtocol <NSObject>
@property (nonatomic, assign) CGSize jz_size;
- (UIView * _Nullable)jz_backgroundView;
- (CGSize)jz_sizeThatFits:(CGSize)size;
@end

@interface UINavigationBar (JZExtension) <JZExtensionBarProtocol>
@end

@interface UIToolbar (JZExtension) <JZExtensionBarProtocol>
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
}

#pragma clang diagnostic pop
