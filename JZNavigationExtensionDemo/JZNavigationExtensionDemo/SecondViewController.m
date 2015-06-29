//
//  SecondViewController.m
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 6/25/15.
//  Copyright (c) 2015 Jazys. All rights reserved.
//

#import "SecondViewController.h"
#import "ViewController.h"
#import "UINavigationController+JZExtension.h"
#import "DemoTableViewCell.h"

#define UIColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@interface SecondViewController ()
@property (weak,   nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *cellModels;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.cellModels[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITableViewCellAccessoryType accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.row) {
        case 0:
            accessoryType = (UITableViewCellAccessoryType)UITableViewCellAccessorySwitch;
            cell.accessoryModel = @{@"on" : @(self.navigationController.fullScreenInteractivePopGestureRecognizer)};
            break;
            
        case 1:
            accessoryType = (UITableViewCellAccessoryType)UITableViewCellAccessoryStepper;
            cell.accessoryModel = @{
                                    @"minimumValue" : @(0),
                                    @"maximumValue" : @(1),
                                    @"stepValue"    : @(0.1),
                                    @"value"        : @(self.navigationController.navigationBarBackgroundAlpha),
                                    @"tintColor"    : UIColorWithRGBA(87, 91, 94, 1)
                                    };
            break;
            
        case 2:
            accessoryType = (UITableViewCellAccessoryType)UITableViewCellAccessoryStepper;
            cell.accessoryModel = @{
                                    @"minimumValue" : @(1),
                                    @"maximumValue" : @(self.view.bounds.size.height),
                                    @"stepValue"    : @(20),
                                    @"value"        : @(self.navigationController.navigationBar.bounds.size.height + 20.),
                                    @"tintColor"    : UIColorWithRGBA(87, 91, 94, 1)
                                    };
            break;

        default:
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            break;
    }
    cell.accessoryType = accessoryType;
    
    __weak typeof(self) weakSelf = self;
    cell.accessoryViewAction = ^(UIView *accessoryView){
        if ([accessoryView isKindOfClass:[UISwitch class]]) {
            UISwitch *accessorySwitch = (UISwitch *)accessoryView;
            weakSelf.navigationController.fullScreenInteractivePopGestureRecognizer = accessorySwitch.isOn;
        } else if ([accessoryView isKindOfClass:[UIStepper class]]) {
            UIStepper *accessoryStep = (UIStepper *)accessoryView;
            if (indexPath.row == 1) {
                [UIView animateWithDuration:0.2 animations:^{
                    weakSelf.navigationController.navigationBarBackgroundAlpha = accessoryStep.value;
                }];
            } else {
                [weakSelf.navigationController setNavigationBarSize:CGSizeMake(tableView.bounds.size.width, accessoryStep.value)];
            }
        }
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellModels.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController = [UIViewController new];
    viewController.view.backgroundColor = UIColorWithRGBA(34, 195, 98, 1.f);
    switch (indexPath.row) {
        case 3:
        {
            UIImageView *tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip_pop_gesture"]];
            viewController.hidesNavigationBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            tipImageView.layer.position = CGPointMake(self.navigationController.fullScreenInteractivePopGestureRecognizer ? viewController.view.center.x : tipImageView.bounds.size.width*0.5, viewController.view.center.y);
            [viewController.view addSubview:tipImageView];
        }
            break;
        case 4:
        {
            viewController.title = @"Pushing";
            [self.navigationController pushViewController:viewController animated:YES completion:^(BOOL finished) {
                viewController.title = @"Pushed";
                viewController.view.backgroundColor = UIColorWithRGBA(253, 69, 67, 1.f);
            }];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - getters
- (NSArray *)cellModels {
    if (!_cellModels) {
        _cellModels = @[
                        @"fullScreenInteractivePopGestureRecognizer",
                        @"navigationBarBackgroundAlpha",
                        @"navigationBarHeight",
                        @"hidesNavigationBarWhenPushed",
                        @"pushViewController:animated:completion:",
                        ];
    }
    return _cellModels;
}

@end
