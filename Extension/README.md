# 常用Cocoa扩展

本着提高效率+降低开发成本+永远不做重复劳动的原则, 特整理本Cocoa扩展库.

本扩展库中的所有代码都充分考虑两个前提, 一是低耦合, 二是高复用.

## UIView

#### 1. 快速访问尺寸/位置属性

 纯代码搭建界面时最费事的就是设置控件的尺寸位置. 宽/高也好, 原点橫/纵坐标也好, 层层读取层层赋值, 甚是麻烦. 现在不用那么大费周章了:

```swift
let testView = UIView(frame: CGRectZero)	// {{0.0, 0.0}, {0.0, 0.0}}
testView.x = 20.0							// {{20.0, 0.0}, {0.0, 0.0}}
testView.y = 30.0							// {{20.0, 30.0}, {0.0, 0.0}}
testView.width = 64.0						// {{20.0, 30.0}, {64.0, 0.0}}
testView.height = 21.0						// {{20.0, 30.0}, {64.0, 21.0}}
print("\(testView.maxX)")					// "84.0" (.x + .width)
print("\(testView.maxY)")					// "51.0" (.y + .height)
print("\(testView.centerX)")				// "52.0" (.x + .width * 0.5)
print("\(testView.centerY)")				// "40.5" (.y + .height * 0.5)
...
```

#### 2. 快速添加角标

iOS系统有在App桌面图标和UITabBarItem的右上角显示角标的功能, 万恶的PM要求其他控件也具有这个功能. 手动加上个UILabel吧? 当然可以, 不过有个更简单的方法:

```swift
let button = UIButton(type: .System)
button.frame = CGRectMake(20.0, 20.0, 44.0, 44.0)
button.addBadge("999")						// 添加角标, 显示999
button.removeBadges()						// 移除角标
```

想自定义角标的位置? 没问题!

```swift
...
button.addBadge("999", at: CGPointMake(0.8, 0.2)) 	// 自己去项目里看效果吧...
```

问题解决!

#### 3. 快速显示加载提示(UIActivityIndicatorView)

进行耗时操作时(例如网络请求), 我们通常使用诸如MBProgressHUD的加载提示框架. 不过, 设想一个场景: 注册时向服务器请求验证码, 这是个耗时的过程, 使用MBProgressHUD作全屏提示? NO! 它会禁止用户与其他控件交互. 何不在获取验证码的按钮上显示UIActivityIndicatorView呢?

```swift
class SignUpViewController: UIViewController {
...
	func didClickButton(sender: UIButton) {
		switch ButtonType(rawValue: sender.tag) {
		...
		case CaptchaButton?:
			sender.startLoading()			// 加载旋转的UIActivityIndicatorView
			break
		...
		}
	}
...
}
```

如何取消加载提示显示?

```swift
sender.ceaseLoading()						// 移除UIActivityIndicatorView
```

备注: 快速显示加载提示的实现还有待改进, 目前的代码能正常工作.

#### 4. 快速截图

有些需求, 需要对屏幕进行截图; 高大上一些的, 需要对某个控件进行截图; 更高逼格的, 对某个看不见的控件进行截图. 怎么办? 很简单:

```swift
class SignUpViewController: UIViewController {
...
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		let screenShot: UIImage = self.view.snapshot()	// 对控制器视图进行截图
		let signUpButtonShot: UIImage = self.signUpButton.snapshot()	// 对注册按钮进行截图
	}
...
}
```

```swift
let invisibleView = UIView(frame: CGRectMake(1000.0, 
											 1000.0, 
											 2000.0, 
											 2000.0))	// 这个视图的长宽超出屏幕尺寸...
self.view.addSubview(invisibleView)						// 而且原点的位置也在屏幕显示范围之外...
let invisibleViewShot = invisibleView.snapshot()		// 但是, 照截不误!
```

## UILabel

#### 快速调整尺寸

UILabel的文本发生了改变, 又得重新计算合适的控件尺寸? 一行代码搞定:

```swift
self.titleLabel.text = "Hello, world!"
...
self.titleLabel.text = "Hello, world, again!"
// 根据文本内容, 字体, 宽高限制和edgeInsets自动计算并调整titleLabel的尺寸(不是位置哦亲)
self.titleLabel.sizeToFitWithTextSizeLimits(CGSizeMake(CGFloat.max, CGFloat.max),
											andInsets: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0))
```

## UIButton

#### 快速调整尺寸

与UILabel的上述扩展方法一样, UIButton也有自动调整尺寸的方法, 而且无须指定textSizeLimits:

```swift
self.button.setTitle("Hello, world!", forState: .Normal)
self.button.sizeToFitWithInsets(UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0))	// 一句代码搞定
```

注: NBUI中的NBButton支持创建4种不同布局的按钮, 图片和标题可上下左右自主排列, 欢迎使用.

## UIFont

#### 快速创建自定义字体

我们为UIFont添加了一系列扩展, 包括字体名称枚举UIFont.Name, 和快速构造自定义字体的方法:

```swift
let noteworthyFont = UIFont(fontName: Name.Noteworthy, size: 19.0)
let helNeueLightFont = UIFont(fontName: Name.HelveticaNeueLight, size: 11.5)
```