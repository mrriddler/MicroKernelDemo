//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit
import MicroKernel

final class ChatApplication: MicroApplication {
    
    deinit {
        print("ChatApplication deinit!")
    }
    
    static func appId() -> String {
        return "3"
    }
    
    func applicationInjectDependency(context: MicroApplicationContext) -> MicroApplicationContext {
        context.injectDependency(registerType: ShoppingCoordinator.self)
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
