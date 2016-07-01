# JZNavigationExtension

[![Version](https://img.shields.io/badge/pod-v1.5.0.1-5193DB.svg)](https://cocoapods.org/pods/JZNavigationExtension)
[![Platform](https://img.shields.io/badge/platform-iOS7+-lightgrey.svg)]()
[![License](https://img.shields.io/badge/license-MIT-2F2F2F.svg)](https://github.com/JazysYu/JZNavigationExtension/blob/master/LICENSE)

JZNavigationExtension integrates many convenient features for UINavigationController.
___
JZNavigationExtension为UINavigationController集成了许多方便的功能。

# Features
* [To gives you a fullscreen interactivePopGestureRecognizer](#FPG)
* [Supply two navigation bar transition style](#NBTS)
* [To hides navigation bar when the view controller is pushed on to a navigation controller](#HNBP)
* [To Push/PopViewController With Blocks](#PWB)
* [To change navigation/tool bar background alpha](#NBTA)
* [To change navigation/tool bar size](#NBTS)
* [To hide navigation bar background alpha during pop gesture is interactiving](#NBD)
* [Change navigation bar tint color by different view controller](#CCVC)

# Overview

![overview](https://raw.githubusercontent.com/JazysYu/JZNavigationExtension/master/Snapshots/JZNavigationExtensionDemo.gif)

![overview](https://raw.githubusercontent.com/JazysYu/JZNavigationExtension/master/Snapshots/JZNavigationExtensionEvolution01.gif)

#	Why JZNavigationExtension?
* Full Screen Pop Gesture Works Perfect With UITableView【全屏Pop手势完美匹配UITableView无冲突】
* Two navigation bar transition style extension. 【两种导航栏动画拓展】
* Enable or disable property for each view controller conveniently.【简单地针对每一个Controller开关属性】
* Pushes/Pops a view controller when hides/shows navigation bar display soomthly【当控制器做Push/Pop时无缝、平滑地显隐导航栏】
* Release some restrictions make your navigation controller stronger【解除一些限制，使你的导航控制器更加强大】
* Follow Apple's API design principles,uses as natural
 as system api【遵循Apple Inc的API设计原则，使用就像系统API一样自然】

# Usage

<a id="FPG"></a>To gives you a fullscreen interactivePopGestureRecognizer【打开全屏Pop手势】:

``` objc
navigationController.jz_fullScreenInteractivePopGestureEnabled = YES;
```
___

<a id="FPG"></a>Set a completion for fullscreen interactivePopGestureRecognizer【全屏Pop手势回调】:

``` objc
[self.navigationController jz_setInteractivePopGestureRecognizerCompletion:^(BOOL finished) {
        if (finished) {
            // Codes
        }
    }];
```
___

<a id="NBTS"></a>Change navigation bar transition style 【改变导航栏动画】:

```objc
navigationController.jz_navigationBarTransitionStyle = JZNavigationBarTransitionStyleDoppelganger
```
___

<a id="HNBP"></a>To hides navigation bar when the view controller is pushed on to a navigation controller【支持转场隐藏、显示导航栏】:
``` objc
UIViewController *viewController = [UIViewController new];
viewController.jz_wantsNavigationBarVisible = NO;
[self.navigationController pushToViewController:viewController animated:YES];
```
___

<a id="PWB"></a>To Push/Pop view controller With blocks【导航控制器转场回调】:
``` objc
[self.navigationController jz_pushViewController:viewController animated:YES completion:^(BOOL finished) {
		///Do any thing
}];
```
___

<a id="NBTA"></a>To adjust navigation/tool bar background alpha【调节导航控制器的导航栏、工具条透明度】:

``` objc
navigationController.jz_navigationBarBackgroundAlpha = yourAlpha;
```
___

<a id="NBTS"></a>To change navigation/tool bar size【改变导航控制器的导航栏、工具条大小】:

``` objc
[navigationController setJz_navigationBarSize:size];
```

___

<a id="NBD"></a>To hide navigation bar background alpha during pop gesture is interactiving【导航栏手势交互时改变导航栏透明度】

``` objc
UIViewController *viewController = [UIViewController new];
viewController.jz_navigationBarBackgroundHidden = YES;
```

![overview](https://raw.githubusercontent.com/JazysYu/JZNavigationExtension/master/Snapshots/JZNavigationExtensionDemo2.gif)
___

<a id="CCVC"></a>Change navigation bar tint color by different view controller【导航栏手势交互时改变导航栏颜色】

``` objc
UIViewController *viewController = [UIViewController new];
viewController.jz_navigationBarTintColor = [UIColor redColor];
```

![overview](https://raw.githubusercontent.com/JazysYu/JZNavigationExtension/master/Snapshots/JZNavigationExtensionDemo3.gif)
___

Many other features please look up public header files...

###### NS_AVAILABLE_IOS(7_0) 

# WIKI
因为许多国内朋友问我的几个API的问题，所以写了一篇文档简单解释了一下，请参考[这里](https://github.com/JazysYu/JZNavigationExtension/wiki)

# Installation
#### Use cocoapods

``` ruby
pod 'JZNavigationExtension'
```

#### Manually
Drag all source files under floder JZNavigationExtension to your project.


# Apps using this library
If you've used this project in a live app, please let me know! Nothing makes me happier than seeing someone else take my work and go wild with it.
If you are using `JZNavigationExtension` in your app or know of an app that uses it, please add it to [this](https://github.com/JazysYu/JZNavigationExtension/wiki/Apps-using-JZNavigationExtension) list.