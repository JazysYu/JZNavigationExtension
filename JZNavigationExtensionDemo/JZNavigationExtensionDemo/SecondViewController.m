//
//  SecondViewController.m
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 6/25/15.
//  Copyright (c) 2015 Jazys. All rights reserved.
//

#import "SecondViewController.h"
#import "UINavigationController+JZExtension.h"
#import "DemoTableViewCell.h"

#define UIColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@interface SecondViewController () <UIViewControllerPreviewingDelegate>
@property (weak,   nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *cellModels;
@property (nonatomic, strong) id <UIViewControllerPreviewing> previewingContext;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    [self.navigationController setInteractivePopGestureRecognizerCompletion:^(BOOL finished) {
        if (finished) {
            NSLog(@"Interactive Pop Finished");
        } else {
            NSLog(@"Interactive Pop Canceled");
        }
    }];
    
    self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
}

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0) {
    UIViewController *previewingViewController = [UIViewController new];
    previewingViewController.view.backgroundColor = [UIColor redColor];
    return previewingViewController;
}
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0) {
    
}

- (void)dealloc {
    [self unregisterForPreviewingWithContext:self.previewingContext];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.cellModels[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UITableViewCellAccessoryType accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
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
                [weakSelf.navigationController setNavigationBarSize:CGSizeMake(0, accessoryStep.value)];
            }
        }
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellModels.count;
}

- (void)push {
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController = [UIViewController new];
    viewController.view.backgroundColor = UIColorWithRGBA(34, 195, 98, 1.f);

    UIImageView *tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip_pop_gesture"]];
    tipImageView.layer.position = CGPointMake(self.navigationController.fullScreenInteractivePopGestureRecognizer ? viewController.view.center.x : tipImageView.bounds.size.width*0.5, viewController.view.center.y);
    [viewController.view addSubview:tipImageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(0, 100, 100, 100);
    [button addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    [viewController.view addSubview:button];
    
    switch (indexPath.row) {
        case 3:
        {
            viewController.wantsNavigationBarVisible = NO;
            [self.navigationController pushViewController:viewController animated:YES];
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
        case 5:
        {
            viewController.navigationBarBackgroundHidden = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
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
                        @"wantsNavigationBarVisible:NO",
                        @"pushViewController:animated:completion:",
                        @"navigationBarBackgroundHidden"
                        ];
    }
    return _cellModels;
}

@end
