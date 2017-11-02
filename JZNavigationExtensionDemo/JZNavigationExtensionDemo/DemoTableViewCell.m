//
//  DemoTableViewCell.m
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 6/26/15.
//  Copyright (c) 2015 Jazys. All rights reserved.
//

#import "DemoTableViewCell.h"

@implementation DemoTableViewCell
- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType {
    switch ((UITableViewCellAccessoryTypeExtension)accessoryType) {
        case UITableViewCellAccessorySwitch:
        {
            UISwitch *accessorySwitch = [UISwitch new];
            [accessorySwitch addTarget:self action:@selector(_triggerAccessoryAction:) forControlEvents:UIControlEventValueChanged];
            self.accessoryView = accessorySwitch;
        }
            break;
        case UITableViewCellAccessoryStepper:
        {
            UIStepper *accessoryStepper = [UIStepper new];
            [accessoryStepper addTarget:self action:@selector(_triggerAccessoryAction:) forControlEvents:UIControlEventValueChanged];
            self.accessoryView = accessoryStepper;
        }
            break;
        default:
            [super setAccessoryType:accessoryType];
            break;
    }
}

- (void)setAccessoryView:(UIView *)accessoryView {
    if (self.accessoryModel) {
        /**
         *  UIStepper needs set maximumValue at first. Then the value will be correct.
         */
        if ([accessoryView isKindOfClass:[UIStepper class]]) {
            [accessoryView setValue:self.accessoryModel[@"maximumValue"] forKey:@"maximumValue"];
        }
        [accessoryView setValuesForKeysWithDictionary:self.accessoryModel];
    }
    [super setAccessoryView:accessoryView];
}

- (void)_triggerAccessoryAction:(UIView *)accessoryView {
    !self.accessoryViewAction ?: self.accessoryViewAction(accessoryView);
}
@end
