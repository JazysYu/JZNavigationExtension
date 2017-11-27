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

@implementation UINavigationBar (JZExtension)

JZExtensionBarImplementation

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ([[self jz_backgroundView] alpha] < 1.0f) {
        return CGRectContainsPoint(CGRectMake(0, self.bounds.size.height - 44.f, self.bounds.size.width, 44.f), point);
    } else {
        return [super pointInside:point withEvent:event];
    }
}

- (UIView *)jz_backgroundView {
    if (@available(iOS 10, *)) {
        return [self valueForKeyPath:@"_backgroundView._backgroundEffectView"];
    }
    return [self valueForKeyPath:@"_backgroundView"];
}

@end

@implementation UIToolbar (JZExtension)

JZExtensionBarImplementation

- (UIView *)jz_backgroundView {
    return [self valueForKey:@"_backgroundView"];
}

@end
