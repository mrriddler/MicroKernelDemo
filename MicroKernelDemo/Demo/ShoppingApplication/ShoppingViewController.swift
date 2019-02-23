//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit
import MicroKernel

class ShoppingViewController: DemoViewController {
    
    override func viewDidLoad() {
        self.title = "Shopping"
        self.view.backgroundColor = UIColor.red
        
        let button = UIButton(frame: CGRect(x: self.view.bounds.size.width / 2 - 125, y: self.view.bounds.size.height / 2 - 25, width: 250, height: 50))
        button.backgroundColor = .green
        button.setTitle("goto ShoppingDetail", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        self.view.addSubview(button)
        
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
            
            payCoordinator.register(subscriber: self, eventName: "Coupon", expectType: CouponCoordinatorEvent.self, handler: { (event) in
                if let event = event {
                    print("Coupon discount is:" + event.discount)
                }
            })

        }
    }
    
    @objc func buttonPressed() {
        UIApplication.shared.delegate?.navigationController()?.pushViewController(ShoppingDetailViewController(), animated: true)
    }
}
