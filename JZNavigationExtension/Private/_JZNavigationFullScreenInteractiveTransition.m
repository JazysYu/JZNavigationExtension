//
//  _FullScreenInteractivePopGestureRecognizerDelegate.m
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 4/23/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import "_JZNavigationFullScreenInteractiveTransition.h"
#import <UIKit/UINavigationBar.h>
#import <UIKit/UINavigationController.h>
#import "UINavigationController+JZExtension.h"
#import "_JZ-objc-internal.h"

@interface _JZNavigationFullScreenInteractiveTransition ()
@property (nonatomic, weak) UINavigationController *navigationController;
@end
@implementation _JZNavigationFullScreenInteractiveTransition

- (instancetype)initWithNavigationController:(id)navigationController {
    self = [super init];
    if (self) {
        self.navigationController = navigationController;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return self.navigationController.viewControllers.count != 1 && ![self.navigationController jz_isTransitioning] && !CGRectContainsPoint(self.navigationController.navigationBar.frame, [touch locationInView:gestureRecognizer.view]);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (!self.navigationController.jz_fullScreenInteractivePopGestureEnabled) {
        return true;
    }
    CGPoint locationInView = [gestureRecognizer locationInView:gestureRecognizer.view];
    return locationInView.x < 30.0f;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint velocityInview = [gestureRecognizer velocityInView:gestureRecognizer.view];
    return velocityInview.x >= 0.0f;
}

@end
