# JZNavigationExtension
The "UINavigationController+JZExtension" category integrates some convenient features and open some hide functions for UINavigationController.
___
"UINavigationController+JZExtension"分类为UINavigationController集成了许多方便的功能点，同时为它打开了一些隐藏功能。
# Features
* [To gives you a fullscreen interactivePopGestureRecognizer](#FPG)
* [To hides navigation bar when the view controller is pushed on to a navigation controller](#HNBP)
* [To Push/PopViewController With Blocks](#PWB)
* [To change navigation/tool bar background alpha](#NBTA)
* [To change navigation/tool bar size](#NBTS)
* [To hide navigation bar background alpha during pop gesture is interactiving](#NBD)

# Overview

![overview](https://raw.githubusercontent.com/JazysYu/JZNavigationExtension/master/Snapshots/JZNavigationExtensionDemo.gif)

#	Why JZNavigationExtension?
* Pop Gesture Works Perfect With UITableView【全屏Pop手势完美匹配UITableView无冲突】
* Enable or disable property for each view controller conveniently.【简单地针对每一个Controller开关属性】
* Pushes/Pops a view controller when hides/shows navigation bar display soomthly【当控制器做Push/Pop时无缝、平滑地显隐导航栏】
* Release some restrictions make your navigation controller stronger【解除一些限制，使你的导航控制器更加强大】
* Follow Apple's API design principles,uses as natural
 as system api【遵循Apple Inc的API设计原则，使用就像系统API一样自然】

# Usage

<a id="FPG"></a>To gives you a fullscreen interactivePopGestureRecognizer【打开全屏Pop手势】:

``` objc
navigationController.fullScreenInteractivePopGestureRecognizer = YES;
```
___

<a id="FPG"></a>Set a completion for fullscreen interactivePopGestureRecognizer【全屏Pop手势回调】:

``` objc
[self.navigationController setInteractivePopGestureRecognizerCompletion:^(BOOL finished) {
        if (finished) {
            // Codes
        }
    }];
```
___

<a id="HNBP"></a>To hides navigation bar when the view controller is pushed on to a navigation controller【支持转场隐藏、显示导航栏】:
``` objc
UIViewController *viewController = [UIViewController new];
viewController.hidesNavigationBarWhenPushed = YES;
[self.navigationController pushToViewController:viewController animated:YES];
```
___

<a id="PWB"></a>To Push/Pop view controller With blocks【导航控制器转场回调】:
``` objc
[self.navigationController pushViewController:viewController animated:YES completion:^(BOOL finished) {
		///Do any thing
}];
```
___

<a id="NBTA"></a>To adjust navigation/tool bar background alpha【调节导航控制器的导航栏、工具条透明度】:

``` objc
navigationController.navigationBarBackgroundAlpha = yourAlpha;
```
___

<a id="NBTS"></a>To change navigation/tool bar size【改变导航控制器的导航栏、工具条大小】:

``` objc
[navigationController setNavigationBarSize:size];
```

___

<a id="NBD"></a>To hide navigation bar background alpha during pop gesture is interactiving

``` objc
UIViewController *viewController = [UIViewController new];
viewController.navigationBarBackgroundHidden = YES;
```


![overview](https://raw.githubusercontent.com/JazysYu/JZNavigationExtension/master/Snapshots/JZNavigationExtensionDemo2.gif)
___

# Installation
#### Use cocoapods

``` ruby
pod 'JZNavigationExtension'
```

#### Manually
Drag all source files under floder JZNavigationExtension to your project.

``` objc
UINavigationController+JZExtension.h	UINavigationController+JZExtension.m
```