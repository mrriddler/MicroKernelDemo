//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import Foundation
import MicroKernel

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
    
    func call(request: CouponRequest, handler: @escaping ((CouponResponse?) -> Void)) {
        handler(CouponResponse(discount: 0.8, deadline: DateFormatter().string(from: Date())))
    }
}
