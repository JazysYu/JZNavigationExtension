// The MIT License (MIT)
//
// Copyright (c) 2015-present JazysYu ( https://github.com/JazysYu )
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

#import <UIKit/UIKit.h>

/**
 *  The "UINavigationController+JZExtension" category integrates some convenient functions, such as gives your UINavigationController a fullscreen interactivePopGestureRecognizer, different navigation bar transition style, and so on.
 */

typedef enum : NSInteger {
    JZNavigationBarTransitionStyleNone = -1,
    JZNavigationBarTransitionStyleSystem,
    JZNavigationBarTransitionStyleDoppelganger
} JZNavigationBarTransitionStyle;

@interface UINavigationController (JZExtension)

/**
 *  Expand two different navigation bar transition style, setting this property for the global navigation transition. It is worth noting that custom navigation transitions or disable navigation bar translucent will crossfade the navigation bar forcibly.
 */
@property (nonatomic, assign) JZNavigationBarTransitionStyle jz_navigationBarTransitionStyle;

/**
 *  If YES, then you can have a fullscreen gesture recognizer responsible for popping the top view controller off the navigation stack, and the property is still "interactivePopGestureRecognizer", see more for "UINavigationController.h", Default is NO.
 */
@property (nonatomic, assign) BOOL jz_fullScreenInteractivePopGestureEnabled;

/**
 *  The toolBar backgroundView's alpha value, default is 1. Animatable
 */
@property (nonatomic, assign) CGFloat jz_toolbarBackgroundAlpha;

/**
 *  The type of transition operation that is occurring. For a list of possible values, see the UINavigationControllerOperation constants.
 */
@property (nonatomic, assign, readonly) UINavigationControllerOperation jz_operation;

/**
 *  The navigationController's last pointer of visibleViewController. Can use this to do any logic during navigation transition in any method you want, like "viewWillAppear:".
 */
@property (nonatomic, weak, readonly) UIViewController *jz_previousVisibleViewController;

/**
 *  Change navigationBar to any size, if you want default value, then set to 0.f.
 */
@property (nonatomic, assign, readwrite) CGSize jz_navigationBarSize;

/**
 *  Change toolBar to any size, if you want default value, then set to 0.f.
 */
@property (nonatomic, assign, readwrite) CGSize jz_toolbarSize;

/**
 *  Return the gives view controller's last view controller in the navigation stack.
 */
- (UIViewController *)jz_previousViewControllerForViewController:(UIViewController *)viewController;

/**
 *  Called at end of animation of push/pop or immediately if not animated. The completion block will be set to nil while transition finished.
 */
- (void)jz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(UINavigationController *navigationController, BOOL finished))completion;

/**
 *  Called at end of animation of push/pop or immediately if not animated. The completion block will be set to nil while transition finished.
 */
- (UIViewController *)jz_popViewControllerAnimated:(BOOL)animated completion:(void (^)(UINavigationController *navigationController, BOOL finished))completion;

/**
 *  Called at end of animation of push/pop or immediately if not animated. The completion block will be set to nil while transition finished.
 */
- (NSArray *)jz_popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(UINavigationController *navigationController, BOOL finished))completion;

/**
 *  Called at end of animation of push/pop or immediately if not animated. The completion block will be set to nil while transition finished.
 */
- (NSArray *)jz_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(UINavigationController *navigationController, BOOL finished))completion;

/**
 *  Called at end of animation of push/pop or immediately if not animated. The completion block will be set to nil while transition finished.
 */
- (void)jz_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void (^)(UINavigationController *navigationController, BOOL finished))completion;

/**
 *  Called at end of interactive pop gesture immediately. Can use visibleViewController/jz_previousVisibleViewController or any other properties to decide what to do.
 */
- (void)jz_setInteractivePopGestureRecognizerCompletion:(void (^)(UINavigationController *navigationController, BOOL finished))jz_interactivePopGestureRecognizerCompletion;

@end
