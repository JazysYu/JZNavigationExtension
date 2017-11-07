//
//  ViewController.m
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 2/2/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import "ViewController.h"
#import "JZNavigationExtension.h"
#import "_JZ-objc-internal.h"

@interface ViewController () <UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    self.navigationController.delegate = self;
//    self.navigationController.jz_navigationBarTransitionStyle = JZNavigationBarTransitionStyleDoppelganger;
}

/**
 *  @author JazysYu, 16-05-27 10:05:21
 *
 *  Some logic
 */
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)toViewController animated:(BOOL)animated {
//    UIViewController *fromViewController = [navigationController visibleViewController];
//    if (fromViewController.....) {
//        navigationController.jz_navigationBarTransitionStyle = JZNavigationBarTransitionStyleDoppelganger;
//    }
//}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

@end
