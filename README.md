# NBFramework

## 0. 准备工作

使用NBF框架之前, 需要对项目作一些配置:

**a**. `TARGETS`>`General`>`Linked Frameworks and Libraries`中添加以下框架:

* SystemConfiguration.framework
* Security.framework
* CoreTelephony.framework
* AVFoundation.framework
* CoreMedia.framework
* CoreVideo.framework
* QuartzCore.framework
* libz.tbd
* libc++.tbd
* libsqlite3.0.tbd
* libiconv.tbd

## 1. 二维码/条形码扫描框架libzbar使用说明

#### 在swift bridging head中导入头文件:

```swift
#import "ZBarSDK.h"
```

#### 添加依赖库(***如已执行准备工作, 跳过此步***)

* QuartzCore
* CoreVideo
* CoreMedia
* AVFoundation
* libiconv

## 2. NBButton使用说明

NBButton可自定义image/title的布局, 除默认的左img/右ttl布局外, 还支持左ttl/右img, 上ttl/下img, 和上img/下ttl:

```swift
let btn = NBButton(layoutType: LayoutType.LeftTitleRightImage)
```

```swift
let btn = NBButton(type: .System)
btn.layoutType = .TopImageBottomTitle
```

除了布局, NBButton也支持快速设置边框和填充色:

```swift
let btn = NBButton(type: .System)
btn.layoutType = .TopImageBottomTitle
btn.borderWidth = 2.0
btn.borderColor = UIColor(R: 239.0, G: 219.0, B: 107.0)
btn.fillColor = UIColor(R: 255.0, G: 233.0, B: 122.0)
```

## 3. MJExtension使用说明
### 在swift bridging head中导入头文件:
```swift
#import "MJExtension.h"
```

 Model类:
 
 .h -> 文件无需任何处理
 
 .m -> 文件
 引入 #import "MJExtension.h"
 遵循 <NSCodeing> 协议
 引用 MJCodingImplementation

```swift
#import "XXX.h"
#import "MJExtension.h"

@interface XXX()<NSCoding>

@end

@implementation UserModel

MJCodingImplementation

@end

```
## 4. WeChatSDK - 接入指南

[iOS接入指南](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=&lang=zh_CN)