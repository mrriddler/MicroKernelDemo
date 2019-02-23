## AppDelegate

从架构上来看，**MainApplication**与**AppDelegate**有重合的地方。在框架实现中，**PlatformMainApplication**是一个与平台相关的**MainApplication**实体，顶替了**AppDelegate**的位置，而要使**AppDelegate**类仍作为App的代理，需要加入main.swift文件，并在其中指明：

```swift
UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    NSStringFromClass(AppDelegate.self)
)
```

而最佳实践就是将**AppDelegate**类继承自**PlatformMainApplication**：

```swift
class AppDelegate: PlatformMainApplication {

    var window: UIWindow?

    var navs: [DemoNavigationController] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        MicroKernel.boot(self)
        registerApplication()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav: DemoNavigationController = DemoNavigationController()
        self.navs.append(nav)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        MicroKernel.open(url: URL(string: "2://")!, options: nil, completionHandler: nil)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerApplication() {
        MicroKernel.registerMicroApplication(ShoppingApplication.self)
        MicroKernel.registerMicroApplication(PayApplication.self)
    }
    
    public override func applicationInjectDependency(_ mainContext: MainApplicationContext) -> MainApplicationContext {
        return mainContext
    }
}
```

在**AppDelegate**启动后，向主应用注册了**MicroApplication**和全局依赖，履行了注册和配置的职责。



## ViewController和NavigationController

由于ViewController,NavigationController和**MicroApplication**的管理有联动，**MicroKernel**提供了**MicroKernelViewController**和**MicroKernelNavigationController**作为基类以供外部继承使用。**MicroKernelViewController**和**MicroKernelNavigationController**只在覆写的方法里与内部数据结构有交互，不会影响ViewController，NavigationController的任何行为，无副作用。



## DriverAspect

在Driver管理、协调内部事务的时候，免不了对外界因素的影响，**DriverAspect**就是提供给外部的切面机制。实现**MicroKernelDriverAspect**并注册，针对Driver切面编程。**NavigationDriverAspect**就是用这种机制实现Driver与ViewController，NavigationControllerDriver的联动。



## RouterInterceptor

处理路由的入参灵活、易错、脆弱，架构中这个位置需要多加小心。**MicroKernelRouterInterceptor**正是设计在这个位置的自定义机制。基于**MicroKernelRouterInterceptor**可以设计自己的跳转规则和标准。而**MicroKernelRouterParam**是跳转入参的数据结构体，拦截器处理的基本单位。框架中实现了检测appId的拦截器：

```swift
internal struct ApplicationRouterInterceptor: MicroKernelRouterInterceptor {
    
    internal func intercept(param: MicroKernelRouterParam) -> MicroKernelRouterParam {
        return param
    }
    
    internal func canOpenURL(param: MicroKernelRouterParam) -> Bool {
        guard let appId: String = param.scheme else {
            return false
        }
        
        return MicroKernel.canLaunchMicroApplication(appId)
    }
}
```

