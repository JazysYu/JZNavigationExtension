//
//  UIToolbar+JZExtension.h
//
//  Created by Jazys on 3/11/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_JZ-objc-internal.h"

@interface UIToolbar (JZExtension) <JZExtensionBarProtocol>

- (UIView * _Nullable)jz_shadowView;

@end
