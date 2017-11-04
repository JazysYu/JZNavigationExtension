//
//  _JZ-objc-internal.m
//  
//
//  Created by Jazys on 04/11/2017.
//  Copyright © 2017 Jazys. All rights reserved.
//

#import "_JZ-objc-internal.h"

@implementation NSNumber (JZExtension)

- (CGFloat)jz_CGFloatValue {
#if CGFLOAT_IS_DOUBLE
    return [self doubleValue];
#else
    return [self floatValue];
#endif
}

@end

@implementation _JZValue
@synthesize weakObjectValue = _weakObjectValue;

+ (_JZValue *)valueWithWeakObject:(id)anObject {
    _JZValue *value = [[self alloc] init];
    value->_weakObjectValue = anObject;
    return value;
}

@end

#define JZNavigationBarHeight 44.f

@implementation UINavigationBar (JZExtension)

JZExtensionBarImplementation

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([[self jz_backgroundView] alpha] < 1.0f) {
        return CGRectContainsPoint(CGRectMake(0, self.bounds.size.height - JZNavigationBarHeight, self.bounds.size.width, JZNavigationBarHeight), point);
    } else {
        return [super pointInside:point withEvent:event];
    }
}

@end

@implementation UIToolbar (JZExtension)

JZExtensionBarImplementation

- (UIView *)jz_shadowView {
    return [self valueForKey:@"_shadowView"];
}

@end
