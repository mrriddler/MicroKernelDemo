//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation
import MicroKernel

final class PayCoordinatorImp: PayCoordinator {
    
    static func isSingleton() -> Bool {
        return false
    }
    
    static func singleton() -> PayCoordinatorImp {
        return PayCoordinatorImp()
    }
}
