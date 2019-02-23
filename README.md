本仓库/文通过模拟一个简单的业务场景，熟悉**MicroKernel**背后的概念和使用。

## 应用

假设现在要做一个购物业务，而购物业务牵涉选购、商家咨询、支付等场景。实质上，每个场景都是独立的模块，为了维护性、拓展性考虑，希望将其充分组件化、减低耦合。架构中的**MicroApplication**正是应对这种情况的设计。

首先，对于选购业务，创建**ShoppingApplication**：

```swift
final class ShoppingApplication: MicroApplication {
    
    static func appId() -> String {
        return "2"
    }
    
    func applicationInjectDependency(context: MicroApplicationContext) -> MicroApplicationContext {
        return context
    }
    
    func applicationWillStartLaunching(_ application: MicroApplication, launchOptions: [MicroApplicationLaunchOptionsKey : Any]?) {
        
        UIApplication.shared.delegate?.navigationController()?.pushViewController(ShoppingViewController(), animated: true)
    }
    
    func applicationDidFinishLaunching(_ application: MicroApplication) {}
    
    func applicationWillResignActive(_ application: MicroApplication) {
        print("ShoppingApplication will resign active!")
    }
    
    func applicationDidResignActive(_ application: MicroApplication) {
        print("ShoppingApplication did resign active!")
    }
    
    func applicationWillBecomeActive(_ application: MicroApplication) {
        print("ShoppingApplication will become active!")
    }
    
    func applicationDidBecomeActive(_ application: MicroApplication) {
        print("ShoppingApplication did become active!")
    }
    
    func applicationWillTerminate(_ application: MicroApplication) {
        print("ShoppingApplication will terminate!")
    }
    
    func applicationDidTerminate(_ application: MicroApplication) {
        print("ShoppingApplication did terminate!")
    }
}
```

**ShoppingApplication**承载了选购业务生命周期，并作为其唯一入口。每个**MicroApplication**有自己的appId，这也是应用的唯一标识，**ShoppingApplication**的appId是2。选购业务启动后，会push **ShoppingViewController**，进入选购页面。

其次，对于商家咨询业务，创建**ChatApplication**，

```swift
final class ChatApplication: MicroApplication {
    
    static func appId() -> String {
        return "3"
    }
    
    func applicationInjectDependency(context: MicroApplicationContext) -> MicroApplicationContext {
        return context
    }
    
    func applicationWillStartLaunching(_ application: MicroApplication, launchOptions: [MicroApplicationLaunchOptionsKey : Any]?) {
        
        if launchOptions?[MicroApplicationLaunchOptionsKey(rawValue: "presentByNav")] != nil {
            let previousVC: UIViewController = UIApplication.shared.delegate!.navigationController()!.viewControllers.last!
            
            let presentNav: DemoNavigationController = UIApplication.shared.delegate!.switchNewNavigationController()
            presentNav.pushViewController(ChatViewController(), animated: true)
            
            previousVC.present(presentNav, animated: true, completion: nil)
        } else {
            let previousVC: UIViewController = UIApplication.shared.delegate!.navigationController()!.viewControllers.last!
            previousVC.present(ChatViewController(), animated: true, completion: nil)
        }
    }
    
    func applicationDidFinishLaunching(_ application: MicroApplication) {}
    
    func applicationWillResignActive(_ application: MicroApplication) {}
    
    func applicationDidResignActive(_ application: MicroApplication) {}
    
    func applicationWillBecomeActive(_ application: MicroApplication) {}
    
    func applicationDidBecomeActive(_ application: MicroApplication) {}
    
    func applicationWillTerminate(_ application: MicroApplication) {}
    
    func applicationDidTerminate(_ application: MicroApplication) {}
}
```

同样，商家咨询业务启动后，会进入商家咨询页面。

最后，对于支付业务，创建**PayApplication**：

```swift
final class PayApplication: MicroApplication {
    
    static func appId() -> String {
        return "4"
    }
    
    func applicationInjectDependency(context: MicroApplicationContext) -> MicroApplicationContext {
        return context
    }
    
    func applicationWillStartLaunching(_ application: MicroApplication, launchOptions: [MicroApplicationLaunchOptionsKey : Any]?) {
        UIApplication.shared.delegate?.navigationController()?.pushViewController(PayViewController(), animated: true)
    }
    
    func applicationDidFinishLaunching(_ application: MicroApplication) {}
    
    func applicationWillResignActive(_ application: MicroApplication) {}
    
    func applicationDidResignActive(_ application: MicroApplication) {}
    
    func applicationWillBecomeActive(_ application: MicroApplication) {}
    
    func applicationDidBecomeActive(_ application: MicroApplication) {}
    
    func applicationWillTerminate(_ application: MicroApplication) {}
    
    func applicationDidTerminate(_ application: MicroApplication) {}
}
```

支付业务启动后，会进入支付页面。



## 业务服务

假设选购现在需要支持分享功能，而分享功能又是一个贯穿App的通用业务服务，则创建**ShareService**和**ShareServiceImp**：

```swift
public protocol ShareService: MicroApplicationService {
    
    func share() -> String
}
```

```swift
final class ShareServiceImp: ShareService {
    
    static func isSingleton() -> Bool {
        return false
    }
    
    static func singleton() -> ShareServiceImp {
        return ShareServiceImp()
    }
    
    deinit {
        print("ShareService deinit!")
    }
    
    required init() {}
    
    func share() -> String {
        return "WeChat"
    }
}
```



## 依赖

在**ShoppingApplication**中声明注入分享依赖：

```swift
    func applicationInjectDependency(context: MicroApplicationContext) -> MicroApplicationContext {
        context.injectDependency(registerType: ShareService.self)
        return context
    }
```

既可以注入主应用包含的全局依赖，也可以注入局部的依赖，局部的依赖会覆盖全局依赖，以获得不同应用的技术方案自治性。

如若要定制化分享功能，创建**ShoppingShareServiceImp**：

```swift
final class ShoppingShareServiceImp: ShareService {
    
    static func isSingleton() -> Bool {
        return false
    }
    
    static func singleton() -> ShoppingShareServiceImp {
        return ShoppingShareServiceImp()
    }
    
    deinit {
        print("ShoppingShareService deinit!")
    }
    
    required init() {}
    
    func share() -> String {
        return "Alipay"
    }
}
```

然后声明注入自定义的分享依赖：

```swift
    func applicationInjectDependency(context: MicroApplicationContext) -> MicroApplicationContext {
        context.injectDependency(registerType: ShareService.self, resloveType: ShoppingShareServiceImp.self)
        return context
    }
```

使用依赖：

```swift
        if let shareService: ShareService = MicroKernel.findDependency(registerType: ShareService.self) as? ShareService {
            print("Share to \(shareService.share())")
        }
```



## 跨模块访问

跨模块访问有两种方式，协调器和事件驱动。

### 协调器

假设在进入商家咨询模块后，需要获取商品的一系列信息，这使得商家咨询模块与选购模块有所耦合。创建**ShoppingCoordinator**，并在其中加入CMPC形式的请求/响应结构体、调用call接口：

```swift
struct ShoppingRequest {
    
    let productId: String
    
    init(productId: String) {
        self.productId = productId
    }
}

struct ShoopingResponse {
    
    let price: String
    
    let detail: String
    
    let imageURL: String
    
    init(price: String, detail: String, imageURL: String) {
        self.price = price
        self.detail = detail
        self.imageURL = imageURL
    }
}

protocol ShoppingCoordinator: MicroApplicationCoordinator {
    
    func call(request: ShoppingRequest, handler: @escaping ((ShoopingResponse?) -> Void))    
}
```

CMPC形成的协调器规定跟随Response的一方。所以，协调器命名为**ShoppingCoordinator**，放在选购业务中。

加入依赖后，就可以使用了：

```swift
    func applicationInjectDependency(context: MicroApplicationContext) -> MicroApplicationContext {
        context.injectDependency(registerType: ShoppingCoordinator.self)
        return context
    }
```

具体实现交给过程调用的接收方，在选购业务模块中加入**ShoppingCoordinatorImp**：

```swift
final class ShoppingCoordinatorImp: ShoppingCoordinator {
    
    static func isSingleton() -> Bool {
        return false
    }
    
    static func singleton() -> ShoppingCoordinatorImp {
        return ShoppingCoordinatorImp()
    }
    
    func call(request: ShoppingRequest, handler: @escaping ((ShoopingResponse?) -> Void)) {
        handler(ShoopingResponse(price: "100", detail: "u should buy it", imageURL: "http://www.baidu.com"))
    }
}
```

过程调用方和接收方都依赖过程调用实体，但没有依赖对方，这就解开了耦合。CMPC形式实际上，由请求/响应结构体、call接口、依赖反转组成。

### 事件驱动

假设在支付后，选购模块需要知道支付的成功与否，这也形成了选购模块和支付模块的耦合，创建**PayCoordinator**：

```swift
struct PaySuccessCoordinatorEvent {
    
    let price: String
    
    init(price: String) {
        self.price = price
    }
}

struct PayFailureCoordinatorEvent {
    
    let comment: String
    
    init(comment: String) {
        self.comment = comment
    }
}

protocol PayCoordinator: MicroApplicationCoordinator {}
```

与CMPC形成的协调器不同，事件驱动形成的协调器规定跟随发布的一方。所以，协调器命名为**PayCoordinator**，放在支付业务中。

支付成功或失败后，由于支付模块作为发起事件的主动方，无需协调器的帮助便可直接发布事件：

```swift
        MicroKernel.post(eventName: "Pay", eventType: PaySuccessCoordinatorEvent.self, event: PaySuccessCoordinatorEvent(price: "1000"))
        MicroKernel.post(eventName: "Pay", eventType: PayFailureCoordinatorEvent.self, event: PayFailureCoordinatorEvent(comment: "TooExpensive"))
```

选购业务，加入依赖：

```swift
    func applicationInjectDependency(context: MicroApplicationContext) -> MicroApplicationContext {
        context.injectDependency(registerType: PayCoordinator.self)
        return context
    }
```

选购业务订阅事件：

```swift
        if let payCoordinator: PayCoordinator = MicroKernel.findDependency(registerType: PayCoordinator.self) as? PayCoordinator {
            
            payCoordinator.register(subscriber: self, eventName: "Pay", expectType: PaySuccessCoordinatorEvent.self, handler: { (event) in
                if let event = event {
                    print("Pay price is:" + event.price)
                }
            })
            
            payCoordinator.register(subscriber: self, eventName: "Pay", expectType: PayFailureCoordinatorEvent.self, handler: { (event) in
                if let event = event {
                    print("Pay deny reason:" + event.comment)
                }
            })
        }
```



## 切换应用

教程在讲述的过程中，有意的略过了如何切换不同的模块，留到此章节来讲述。可以通过**MicroKernel**的接口来开启和结束应用：

```swift
    public class func launchApplication(appId: String, launchOptions: [MicroApplicationLaunchOptionsKey: Any]?)

    public class func terminateToApplication(appId: String)
```

而结束应用接口会同样结束直到遇到第一个具有给出appId应用路径上的所有应用。虽然，可以通过appId来开启应用，但还是建议使用URL的方式来启动，这便于动态化和统一规范化。URL中的scheme会被当做appId来启动应用，例如打开选购业务应用：

```swift
MicroKernel.open(url: URL(string: "2://")!, options: nil, completionHandler: nil)
```

