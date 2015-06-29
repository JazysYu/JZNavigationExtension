//
//  DemoTableViewCell.h
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 6/26/15.
//  Copyright (c) 2015 Jazys. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UITableViewCellAccessoryTypeExtension) {
    /*
    UITableViewCellAccessoryNone,                   // don't show any accessory view
    UITableViewCellAccessoryDisclosureIndicator,    // regular chevron. doesn't track
    UITableViewCellAccessoryDetailDisclosureButton, // info button w/ chevron. tracks
    UITableViewCellAccessoryCheckmark,              // checkmark. doesn't track
    UITableViewCellAccessoryDetailButton NS_ENUM_AVAILABLE_IOS(7_0) // info button. tracks
    */
    UITableViewCellAccessorySwitch = UITableViewCellAccessoryDetailButton + 1,
    UITableViewCellAccessoryStepper
};
@interface DemoTableViewCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *accessoryModel; // Set the View's property with KVC
@property (nonatomic, copy) void(^accessoryViewAction)(UIView *accessoryView);
@end
