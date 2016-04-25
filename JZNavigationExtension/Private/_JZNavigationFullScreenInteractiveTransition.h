//
//  _FullScreenInteractivePopGestureRecognizerDelegate.h
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 4/23/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import <UIKit/UIPanGestureRecognizer.h>

@class UINavigationController;
@interface _JZNavigationFullScreenInteractiveTransition : NSObject <UIGestureRecognizerDelegate>
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;
@end
