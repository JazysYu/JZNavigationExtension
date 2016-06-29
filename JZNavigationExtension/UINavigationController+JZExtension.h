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

#import <UIKit/UIKit.h>

/// The "UINavigationController+JZExtension" category integrates many convenient functions, such as gives your UINavigationController a fullscreen interactivePopGestureRecognizer, different navigation bar transition style, or customise navigation bar tint color for each view controller.
/// If you have some ViewController which doesn't wants a navigation bar, you can set the "jz_wantsNavigationBarVisible"
/// property to NO.
/// You can also adjust your navigationBar or toolbar's background alpha.

typedef enum : NSInteger {
    JZNavigationBarTransitionStyleNone = -1,
    JZNavigationBarTransitionStyleSystem,
    JZNavigationBarTransitionStyleDoppelganger
} JZNavigationBarTransitionStyle;

@interface UINavigationController (JZExtension)

/**
 *  @author JazysYu, 16-05-09 10:05:41
 *
 *  Expand two different navigation bar transition style, setting this property for the global navigation transition. It is worth noting that custom navigation transitions or disable navigation bar translucent will crossfade the navigation bar forcibly.
 */
@property (nonatomic, assign) JZNavigationBarTransitionStyle jz_navigationBarTransitionStyle;

/**
 *  @author JazysYu, 16-01-25 14:01:53
 *
 *  If YES, then you can have a fullscreen gesture recognizer responsible for popping the top view controller off the navigation stack, and the property is still "interactivePopGestureRecognizer", see more for "UINavigationController.h", Default is NO.
 */
@property (nonatomic, assign) BOOL jz_fullScreenInteractivePopGestureEnabled;

/**
 *  @author JazysYu, 16-01-25 14:01:24
 *
 *  navigationBar's background alpha, when 0 your navigationBar will be invisable, default is 1. Animatable
 */
@property (nonatomic, assign) CGFloat jz_navigationBarBackgroundAlpha;

/**
 *  @author JazysYu, 16-01-25 14:01:57
 *
 *  Current navigationController's toolbar background alpha, make sure the toolbarHidden property is NO, default is 1. Animatable
 */
@property (nonatomic, assign) CGFloat jz_toolbarBackgroundAlpha;

/**
 *  @author JazysYu, 16-03-12 16:03:12
 *
 *  Could use this propery to adjust navigation controller's operation, then do some logic.
 *
 */
@property (nonatomic, assign, readonly) UINavigationControllerOperation jz_operation;

/**
 *  @author JazysYu, 16-03-12 16:03:39
 *
 *  Return the previous visible view controller in navigation controller. Could use this to do any logic during navigation transition in any method you want, like "viewWillAppear:". This can is a replacement of property "interactivePopedViewController".
 */
@property (nonatomic, weak, readonly) UIViewController *jz_previousVisibleViewController;

/**
 *  @author JazysYu, 16-01-25 14:01:04
 *
 *  Change navigationBar to any size, if you want default value, then set to 0.f.
 */
@property (nonatomic, assign, readwrite) CGSize jz_navigationBarSize;

/**
 *  @author JazysYu, 16-01-25 14:01:06
 *
 *  Change toolBar to any size, if you want default value, then set to 0.f.
 */
@property (nonatomic, assign, readwrite) CGSize jz_toolbarSize;

/**
 *  @author JazysYu, 16-01-25 14:01:37
 *
 *  Return the gives view controller's previous view controller in the navigation stack.
 *
 */
- (UIViewController *)jz_previousViewControllerForViewController:(UIViewController *)viewController;

/**
 *  @author JazysYu, 16-01-25 14:01:20
 *
 *  Called at end of animation of push/pop or immediately if not animated. The completion block will be set to nil while transition finish.
 *
 */
- (void)jz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(UINavigationController *navigationController, BOOL finished))completion;

/**
 *  @author JazysYu, 16-01-25 14:01:20
 *
 *  Called at end of animation of push/pop or immediately if not animated. The completion block will be set to nil while transition finish.
 *
 */
- (UIViewController *)jz_popViewControllerAnimated:(BOOL)animated completion:(void (^)(UINavigationController *navigationController, BOOL finished))completion;

/**
 *  @author JazysYu, 16-01-25 14:01:20
 *
 *  Called at end of animation of push/pop or immediately if not animated. The completion block will be set to nil while transition finish.
 *
 */
- (NSArray *)jz_popToRootViewControllerAnimated:(BOOL)animated completion:(void (^)(UINavigationController *navigationController, BOOL finished))completion;

/**
 *  @author JazysYu, 16-01-25 14:01:20
 *
 *  Called at end of animation of push/pop or immediately if not animated. The completion block will be set to nil while transition finish.
 *
 */
- (NSArray *)jz_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(UINavigationController *navigationController, BOOL finished))completion;

/**
 *  @author JazysYu, 16-03-13 19:03:05
 *
 *  Called at end of animation of push/pop or immediately if not animated. The completion block will be set to nil while transition finish.
 *
 */
- (void)jz_setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated completion:(void (^)(UINavigationController *navigationController, BOOL finished))completion;

/**
 *  @author JazysYu, 16-01-25 14:01:20
 *
 *  Called at end of interactive pop gesture immediately. You could use poppedViewController/visibleViewController/jz_previousVisibleViewController properties to decide what to do.
 *
 */
- (void)jz_setInteractivePopGestureRecognizerCompletion:(void (^)(UINavigationController *navigationController, BOOL finished))jz_interactivePopGestureRecognizerCompletion;

@end
