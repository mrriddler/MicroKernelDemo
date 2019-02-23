//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation
import MicroKernel

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

struct CouponRequest {
    
    let productId: String
    
    init(productId: String) {
        self.productId = productId
    }
}

struct CouponResponse {
    
    let discount: Float
    
    let deadline: String
    
    init(discount: Float, deadline: String) {
        self.discount = discount
        self.deadline = deadline
    }
}

protocol ShoppingCoordinator: MicroApplicationCoordinator {
    
    func call(request: ShoppingRequest, handler: @escaping ((ShoopingResponse?) -> Void))
    
    func call(request: CouponRequest, handler: @escaping ((CouponResponse?) -> Void))
}
