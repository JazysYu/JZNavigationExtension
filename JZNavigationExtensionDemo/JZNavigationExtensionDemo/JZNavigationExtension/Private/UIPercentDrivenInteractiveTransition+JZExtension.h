//
//  UIPercentDrivenInteractiveTransition+JZExtension.h
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 3/11/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPercentDrivenInteractiveTransition (JZExtension)
- (id)jz_parent;
- (void)jz_updateInteractiveTransition:(CGFloat)percentComplete;
- (void)jz_cancelInteractiveTransition;
- (void)jz_finishInteractiveTransition;
@end
