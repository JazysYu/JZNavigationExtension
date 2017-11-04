//
//  _JZNavigationControllerDelegate.h
//  
//
//  Created by Jazys on 8/29/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import <UIKit/UINavigationController.h>

@interface _JZNavigationDelegating : NSObject <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

@end
