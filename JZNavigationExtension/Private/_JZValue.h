//
//  _JZValue.h
//
//  Created by Jazys on 3/12/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _JZValue : NSObject
+ (_JZValue *)valueWithWeakObject:(id)anObject;
@property (weak, readonly) id weakObjectValue;
@end
