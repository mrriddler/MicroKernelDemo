//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit
import MicroKernel

final class ShoppingApplication: MicroApplication {
    
    deinit {
        print("Shopping deinit!")
    }
    
    static func appId() -> String {
        return "2"
    }
    
    func applicationInjectDependency(context: MicroApplicationContext) -> MicroApplicationContext {
        context.injectDependency(registerType: ShareService.self, resloveType: ShoppingShareServiceImp.self)
        context.injectDependency(registerType: PayCoordinator.self)
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
