//
//  _JZValue.m
//
//  Created by Jazys on 3/12/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import "_JZValue.h"

@implementation _JZValue
@synthesize weakObjectValue = _weakObjectValue;

+ (_JZValue *)valueWithWeakObject:(id)anObject {
    _JZValue *value = [[self alloc] init];
    value->_weakObjectValue = anObject;
    return value;
}

@end
