# NBFramework

## 1. 二维码/条形码扫描框架libzbar使用说明

#### 在swift bridging head中导入头文件:

```swift
#import "ZBarSDK.h"
```

#### 添加依赖库

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