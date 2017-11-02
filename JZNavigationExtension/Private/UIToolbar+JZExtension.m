//
//  UIToolbar+JZExtension.m
//
//  Created by Jazys on 3/11/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import "UIToolbar+JZExtension.h"

@implementation UIToolbar (JZExtension)

JZExtensionBarImplementation

- (UIView *)jz_shadowView {
    return jz_getProperty(self, @"_shadowView");
}

@end
