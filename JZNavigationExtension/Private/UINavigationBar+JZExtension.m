//
//  UINavigationBar+JZExtension.m
//
//  Created by Jazys on 3/11/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import "UINavigationBar+JZExtension.h"

@implementation UINavigationBar (JZExtension)

JZExtensionBarImplementation

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([[self jz_backgroundView] alpha] < 1.0f) {
        return CGRectContainsPoint(CGRectMake(0, self.bounds.size.height - JZNavigationBarHeight, self.bounds.size.width, JZNavigationBarHeight), point);
    } else {
        return [super pointInside:point withEvent:event];
    }
}

- (void)setJz_transitionAnimated:(BOOL)jz_transitionAnimated {
    objc_setAssociatedObject(self, @selector(jz_transitionAnimated), @(jz_transitionAnimated), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)jz_transitionAnimated {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end