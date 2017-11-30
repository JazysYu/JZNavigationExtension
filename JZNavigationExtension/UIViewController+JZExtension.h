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

@interface UIViewController (JZExtension)

/**
 *  More behavior description https://github.com/JazysYu/JZNavigationExtension/wiki/Welcome-to-the-JZNavigationExtension-wiki!
 */

/**
*  Setting this property changes the visibility of the navigation bar with animating the changes. If have not set, this property will not work. Set this property to UINavigationController for global behavior.
*/
@property (nonatomic, assign) IBInspectable BOOL jz_wantsNavigationBarVisible DEPRECATED_MSG_ATTRIBUTE("Use jz_navigationBarHidden instead");

/**
 *  Setting this property changes the visibility of the navigation bar with animating the changes. If have not set, this property will not work. Set this property to UINavigationController for global behavior.
 */
@property (nonatomic, assign) IBInspectable BOOL jz_navigationBarHidden;

/**
 *  The navigationBar backgroundView's alpha value, default is 1. Animatable. If have not set, this property will not work. Set this property to UINavigationController for global behavior.
 */
@property (nonatomic, assign) IBInspectable CGFloat jz_navigationBarBackgroundAlpha;

/**
 *  The tint color to apply to the navigation bar background. If have not set, this property will not work. Set this property to UINavigationController for global behavior.
 */
@property (nonatomic, strong) IBInspectable UIColor *jz_navigationBarTintColor;

/**
 *  The navigationController's "interactivePopGestureRecognizer" enable state for each view controller. If have not set, this property will not work. Set this property to UINavigationController for global behavior.
 */
@property (nonatomic, assign) IBInspectable BOOL jz_navigationInteractivePopGestureEnabled;

/**
 *  A warpper of "jz_navigationBarBackgroundAlpha".
 */
@property (nonatomic, assign, getter=jz_isNavigationBarBackgroundHidden, setter=jz_setNavigationBarBackgroundHidden:) IBInspectable BOOL jz_navigationBarBackgroundHidden;

/**
 *  The duration of animation will be set to UINavigationControllerHideShowBarDuration.
 */
- (void)jz_setNavigationBarBackgroundHidden:(BOOL)jz_navigationBarBackgroundHidden animated:(BOOL)animated NS_AVAILABLE_IOS(8_0);

/**
 *  The view controller's last view controller in the navigation stack.
 */
- (UIViewController *)jz_previousViewController;

@end
