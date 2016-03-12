//
//  UIViewController+JZExtension.h
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 3/11/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (JZExtension)

/**
 *  @author JazysYu, 16-01-25 14:01:14
 *
 *  This property may only be used during push/pop function called. Default is YES.
 */
@property (nonatomic, assign) IBInspectable BOOL jz_wantsNavigationBarVisible;

/**
 *  @author JazysYu, 16-01-25 14:01:57
 *
 *  Worked on each view controller's push or pop, set the alpha value if you want to apply specific bar alpha to the view controller. If you have not set this property then the value will be as same as the property of navigation controller.
 */
@property (nonatomic, assign) IBInspectable CGFloat jz_navigationBarBackgroundAlpha;

/**
 *  @author dongxinb, 16-01-25 14:01:35
 *
 *  Worked on each view controller's push or pop, set the color value if you want to apply specific bar tint color to the view controller. If your 'navigationBar.barTintColor' is nil, it will automatically set 'navigationBarTintColor' based on your barStyle. Default is navigationBar.barTintColor
 */
@property (nonatomic, strong) IBInspectable UIColor *jz_navigationBarTintColor;

/**
 *  @author dongxinb, 16-01-25 14:01:36
 *
 *  Hide or show the navigation bar background.
 */
@property (nonatomic, assign, getter=isJz_navigationBarBackgroundHidden) IBInspectable BOOL jz_navigationBarBackgroundHidden;

/**
 *  @author dongxinb, 16-01-25 14:01:32
 *
 *  Hide or show the navigation bar background. If animated, it will transition vertically using UINavigationControllerHideShowBarDuration.
 *
 */
- (void)setJz_navigationBarBackgroundHidden:(BOOL)jz_navigationBarBackgroundHidden animated:(BOOL)animated NS_AVAILABLE_IOS(8_0);

/**
 *  @author JazysYu, 16-01-25 14:01:31
 *
 *  Return the gives view controller's previous view controller in the navigation stack.
 *
 */
- (UIViewController *)jz_previousViewController;

@end
