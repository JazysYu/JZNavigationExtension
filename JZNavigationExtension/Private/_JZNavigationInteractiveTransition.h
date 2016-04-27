//
//  _JZNavigationInteractiveTransition.h
//
//  Created by Jazys on 4/23/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import <UIKit/UIPanGestureRecognizer.h>
#import <UIKit/UIViewControllerTransitioning.h>

@class UINavigationController;
@interface _JZNavigationInteractiveTransition : UIPercentDrivenInteractiveTransition <UIGestureRecognizerDelegate>
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;
@end
