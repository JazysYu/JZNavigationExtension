//
//  UINavigationBar+JZExtension.h
//
//  Created by Jazys on 3/11/16.
//  Copyright © 2016 Jazys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "_JZ-objc-internal.h"

@interface UINavigationBar (JZExtension) <JZExtensionBarProtocol>

@property (nonatomic, copy) dispatch_block_t jz_inject_popForTouchAtPoint;

@end
