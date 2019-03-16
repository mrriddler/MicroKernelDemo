//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit
import MicroKernel

class AppDelegate: PlatformMainApplication {

    var window: UIWindow?

    var navs: [DemoNavigationController] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        MicroKernel.boot(self)
        registerApplication()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let nav: DemoNavigationController = DemoNavigationController()
        nav.delegate = nav
        
        self.navs.append(nav)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        MicroKernel.open(url: URL(string: "1://")!, options: nil, completionHandler: nil)
        
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
        MicroKernel.registerMicroApplication(FeedApplication.self)
        MicroKernel.registerMicroApplication(ShoppingApplication.self)
        MicroKernel.registerMicroApplication(ChatApplication.self)
        MicroKernel.registerMicroApplication(PayApplication.self)
        MicroKernel.registerMicroApplication(LogisticsApplication.self)
    }
    
    open override func applicationInjectDependency(_ mainContext: MainApplicationContext) -> MainApplicationContext {
        
        mainContext.injectDependency(registerType: ShareService.self, resloveType: ShareServiceImp.self)
        mainContext.injectDependency(registerType: ShoppingCoordinator.self, resloveType: ShoppingCoordinatorImp.self)
        mainContext.injectDependency(registerType: PayCoordinator.self, resloveType: PayCoordinatorImp.self)
        
        return mainContext
    }
}

extension UIApplicationDelegate {
    
    func switchNewNavigationController() -> DemoNavigationController {
        let newNav: DemoNavigationController = DemoNavigationController()
        newNav.delegate = newNav
        
        let delegate = self as! AppDelegate
        delegate.navs.append(newNav)
        
        return newNav
    }
    
    func switchOldNavigationController() -> DemoNavigationController? {
        let delegate = self as! AppDelegate
        if delegate.navs.count > 1 {
            delegate.navs.removeLast()
        }
        return delegate.navs.last
    }
    
    func navigationController() -> DemoNavigationController? {
        let delegate = self as! AppDelegate
        return delegate.navs.last
    }
}


