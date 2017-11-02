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

@interface UIViewController (JZExtension)

/**
 *  @author JazysYu, 16-01-25 14:01:14
 *
 *  Adjust navigation bar hidden state for view controller in anytime you want. If have not set, this property will not work.
 */
@property (nonatomic, assign) IBInspectable BOOL jz_wantsNavigationBarVisible;

/**
 *  @author JazysYu, 16-01-25 14:01:57
 *
 *  Worked on each view controller's push or pop, set the alpha value if you want to apply specific bar alpha to the view controller. If you have not set this property then the value will be the current navigation bar background alpha dynamically.
 */
@property (nonatomic, assign) IBInspectable CGFloat jz_navigationBarBackgroundAlpha;

/**
 *  @author dongxinb, 16-01-25 14:01:35
 *
 *  Worked on each view controller's push or pop, set the color value if you want to apply specific bar tint color to the view controller. If you have not set this property then the value will be the current navigation bar barTintColor dynamically. Set it to "nil", when you expect a system default color.
 */
@property (nonatomic, strong) IBInspectable UIColor *jz_navigationBarTintColor;

/**
 *  @author dongxinb, 16-01-25 14:01:36
 *
 *  Hide or show the navigation bar background.
 */
@property (nonatomic, assign, getter=jz_isNavigationBarBackgroundHidden, setter=jz_setNavigationBarBackgroundHidden:) IBInspectable BOOL jz_navigationBarBackgroundHidden;

/**
 *  @author dongxinb, 16-01-25 14:01:32
 *
 *  Hide or show the navigation bar background. If animated, it will transition vertically using UINavigationControllerHideShowBarDuration.
 *
 */
- (void)jz_setNavigationBarBackgroundHidden:(BOOL)jz_navigationBarBackgroundHidden animated:(BOOL)animated NS_AVAILABLE_IOS(8_0);

/**
 *  @author JazysYu, 16-01-25 14:01:31
 *
 *  Return the gives view controller's previous view controller in the navigation stack.
 *
 */
- (UIViewController *)jz_previousViewController;

@end
