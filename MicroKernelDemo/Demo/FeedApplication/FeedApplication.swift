//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit
import MicroKernel

final class FeedApplication: MicroApplication {
    
    static func appId() -> String {
        return "1"
    }
    
    func applicationInjectDependency(context: MicroApplicationContext) -> MicroApplicationContext {
        context.injectDependency(registerType: ShareService.self)
        return context
    }
    
    func applicationWillStartLaunching(_ application: MicroApplication, launchOptions: [MicroApplicationLaunchOptionsKey : Any]?) {
        
        UIApplication.shared.delegate?.navigationController()?.pushViewController(FeedViewController(), animated: true)
    }
    
    func applicationDidFinishLaunching(_ application: MicroApplication) {}
    
    func applicationWillResignActive(_ application: MicroApplication) {}
    
    func applicationDidResignActive(_ application: MicroApplication) {}
    
    func applicationWillBecomeActive(_ application: MicroApplication) {}
    
    func applicationDidBecomeActive(_ application: MicroApplication) {}
    
    func applicationWillTerminate(_ application: MicroApplication) {}
    
    func applicationDidTerminate(_ application: MicroApplication) {}
}
