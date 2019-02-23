//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation
import MicroKernel

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

struct CouponCoordinatorEvent {
    
    let discount: String
    
    init(discount: String) {
        self.discount = discount
    }
}

protocol PayCoordinator: MicroApplicationCoordinator {}
