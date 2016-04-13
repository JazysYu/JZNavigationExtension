//
//  SecondViewController.m
//  JZNavigationExtensionDemo
//
//  Created by Jazys on 6/25/15.
//  Copyright (c) 2015 Jazys. All rights reserved.
//

#import "SecondViewController.h"
#import "JZNavigationExtension.h"
#import "DemoTableViewCell.h"

#define UIColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@interface SecondViewController () <UIViewControllerPreviewingDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL _didRegisterForPreviewing;
}
@property (weak,   nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *cellModels;
@property (nonatomic, strong) id <UIViewControllerPreviewing> previewingContext;
@end

@implementation SecondViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.navigationController.jz_previousVisibleViewController isKindOfClass:NSClassFromString(@"ViewController")]) {
        NSLog(@"Came from ViewController Class.");
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.jz_operation == UINavigationControllerOperationPop) {
        NSLog(@"Controller will be poped.");
    } else if (self.navigationController.jz_operation == UINavigationControllerOperationPush) {
        NSLog(@"Controller will push to another.");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    [self.navigationController jz_setInteractivePopGestureRecognizerCompletion:^(UINavigationController *navigationController, BOOL finished) {
        if (finished) {
            NSLog(@"Interactive pop transition has been finished");
        } else {
            NSLog(@"Interactive pop transition has been canceled");
        }
        NSLog(@"%@",navigationController.jz_previousVisibleViewController);
    }];
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
        {
            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
            _didRegisterForPreviewing = true;
        }
    }
}

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0) {
    UIViewController *previewingViewController = [UIViewController new];
    previewingViewController.view.backgroundColor = [UIColor redColor];
    return previewingViewController;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0) {
    
}

- (void)dealloc {
    if (_didRegisterForPreviewing) {
        [self unregisterForPreviewingWithContext:self.previewingContext];
    }
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
            cell.accessoryModel = @{@"on" : @(self.navigationController.jz_fullScreenInteractivePopGestureRecognizer)};
            break;
            
        case 1:
            accessoryType = (UITableViewCellAccessoryType)UITableViewCellAccessoryStepper;
            cell.accessoryModel = @{
                                    @"minimumValue" : @(0),
                                    @"maximumValue" : @(1),
                                    @"stepValue"    : @(0.1),
                                    @"value"        : @(self.navigationController.jz_navigationBarBackgroundAlpha),
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
            weakSelf.navigationController.jz_fullScreenInteractivePopGestureRecognizer = accessorySwitch.isOn;
        } else if ([accessoryView isKindOfClass:[UIStepper class]]) {
            UIStepper *accessoryStep = (UIStepper *)accessoryView;
            if (indexPath.row == 1) {
                [UIView animateWithDuration:0.2 animations:^{
                    weakSelf.jz_navigationBarBackgroundAlpha = accessoryStep.value;
                }];
            } else {
                [weakSelf.navigationController setJz_navigationBarSize:CGSizeMake(0, accessoryStep.value)];
            }
        }
    };
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellModels.count;
}

- (void)push {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SecondViewController"];
    vc.view.backgroundColor = [UIColor redColor];
    vc.jz_navigationBarTintColor = [UIColor blueColor];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *viewController = [UIViewController new];
    viewController.view.backgroundColor = UIColorWithRGBA(34, 195, 98, 1.f);

    UIImageView *tipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip_pop_gesture"]];
    tipImageView.layer.position = CGPointMake(self.navigationController.jz_fullScreenInteractivePopGestureRecognizer ? viewController.view.center.x : tipImageView.bounds.size.width*0.5, viewController.view.center.y);
    [viewController.view addSubview:tipImageView];
    
    switch (indexPath.row) {
        case 3:
        {
            viewController.jz_wantsNavigationBarVisible = NO;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 4:
        {
            viewController.title = @"Pushing";
            [self.navigationController jz_pushViewController:viewController animated:YES completion:^(UINavigationController *navigationController, BOOL finished) {
                viewController.title = @"Pushed";
                viewController.view.backgroundColor = UIColorWithRGBA(253, 69, 67, 1.f);
            }];
        }
            break;
        case 5:
        {
            viewController.jz_navigationBarBackgroundHidden = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 6:
        {
            self.jz_navigationBarBackgroundAlpha = 1.f;
            viewController.jz_navigationBarBackgroundAlpha = 0.3;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 7:
        {
            self.jz_navigationBarTintColor = nil;
            viewController.jz_navigationBarTintColor = [UIColor redColor];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 8:
        {
            NSMutableArray *viewControllers = [[self.navigationController viewControllers] mutableCopy];
            [viewControllers addObject:viewController];
            viewController.title = @"Pushing";
            viewController.jz_navigationBarTintColor = [UIColor purpleColor];
            [self.navigationController jz_setViewControllers:viewControllers animated:YES completion:^(UINavigationController *navigationController, BOOL finished) {
                viewController.title = @"Pushed";
                viewController.view.backgroundColor = UIColorWithRGBA(253, 69, 67, 1.f);
            }];
            return;
        }
            break;
        default:
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Test" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView setEditing:false animated:false];
        [self push];
    }];
    return @[rowAction];
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
                        @"navigationBarBackgroundHidden",
                        @"navigationBarBackgroundAlpha:0.3",
                        @"navigationBarTintColor:",
                        @"setViewControllers:Animated:"
                        ];
    }
    return _cellModels;
}

@end
