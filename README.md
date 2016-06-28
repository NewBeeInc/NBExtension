# NBFramework

## 安装方法

目前推荐使用`git submodule`来安装NBF框架:

```sh
$ git submodule add https://github.com/NewBeeInc/NBFramework.git </relative/path/to/submodules/>
```

clone结束后, 在Xcode中添加NBF的文件夹, 然后进行以下配置.

## 项目配置

#### 1. 添加依赖框架
`TARGETS`>`General`>`Linked Frameworks and Libraries`中添加以下框架:

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

#### 2. 设置OC/Swift桥接头文件
创建OC/Swift桥接头文件, 在`TARGETS`>`Build Settings`>`Objective-C Bridging Header`中设置该文件完整的相对路径, 然后将NBF中`swift-oc-bridging-header.h`文件中的全部代码拷贝至新创建的桥接头文件中, 即可.

#### 3. 关闭Bitcode
由于Zbar静态库较老, 不支持Bitcode, 需要进行关闭: `TARGETS`>`Build Settings`>`Enable Bitcode`>`No`


***
***===>>> 完成以上配置之后才能保证NBF的正常编译, 也就是说一旦编译报错, 请重新以上配置是否有遗漏. <<<===***
***



## 二维码扫描 - NBQRCodeScanViewController

#### 1. 创建界面

`NBQRCodeScanViewController`目前支持两种风格的界面: 全屏(默认)和自定义(扫描框+动画):

```swift
// 全屏(默认)
let qrcodeScanVC = NBQRCodeScanViewController.init(style: NBQRCodeScanViewController.Style.FullScreen)
// 或者自定义
let qrcodeScanVC = NBQRCodeScanViewController.init(style: NBQRCodeScanViewController.Style.Custom)
```
#### 2. 获取扫描结果

在创建`NBQRCodeScanViewController`之后, 设置`readerDelegate`属性成为控制器的代理, 遵守协议`ZBarReaderDelegate`并实现如下方法:

```swift
// 该方法属于代理协议 UIImagePickerControllerDelegate
func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
	// 对扫描结果进行解析
	print(NBQRCodeScanViewController.extractResult(info))
}
```

## 自定义按钮 - NBButton使用说明

#### 1. 自定义布局

NBButton可自定义image/title的布局, 除默认的左img/右ttl布局外, 还支持**左ttl/右img**, **上ttl/下img**, 和**上img/下ttl**:

```swift
let btn = NBButton(layoutType: LayoutType.LeftTitleRightImage)
```

```swift
let btn = NBButton(type: .System)
btn.layoutType = .TopImageBottomTitle
```
#### 2. 自定义边框
除了布局, NBButton也支持快速设置边框和填充色:

```swift
let btn = NBButton(type: .System)
btn.layoutType = .TopImageBottomTitle
btn.borderWidth = 2.0
btn.borderColor = UIColor(R: 239.0, G: 219.0, B: 107.0)
btn.fillColor = UIColor(R: 255.0, G: 233.0, B: 122.0)
```

## 快速模型类创建 - MJExtension使用说明

快速生成模型类分两步:
#### 1. 在`.h`文件中指定模型的属性列表
通常, 保持属性名与服务器接口返回值中对应的字段名一致, 这样能节省大量的开发时间.

#### 2. 在`.m`文件中引入宏
直接上代码:

```swift
#import "XXX.h"
#import "MJExtension.h"

@interface XXX () <NSCoding>
@end
@implementation UserModel
MJCodingImplementation	// 这是一个OC宏
@end
```
#### 3. 字典->模型

```swift
// 假设定义模型类ModelA
class ModelA: NSObject {
	...
}
// 假设从服务端接口返回值中获取数据字典dict, 类型为Dictionary<String, AnyObject> ...
// 将dict转化为模型对象的方法如下:
let model = ModelA(keyValues: dict)
```
