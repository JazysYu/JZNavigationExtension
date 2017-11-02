//
//  NSNumber+JZExtension.m
//
//  Created by Jazys on 3/11/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import "NSNumber+JZExtension.h"

@implementation NSNumber (JZExtension)

- (CGFloat)jz_CGFloatValue {
#if CGFLOAT_IS_DOUBLE
    return [self doubleValue];
#else
    return [self floatValue];
#endif
}

@end
