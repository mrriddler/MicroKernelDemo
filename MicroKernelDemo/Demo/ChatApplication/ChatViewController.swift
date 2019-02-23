//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit
import MicroKernel

class ChatViewController: DemoViewController {
    
    override func viewDidLoad() {
        self.title = "Chat"
        self.view.backgroundColor = UIColor.magenta
        
        let payButton = UIButton(frame: CGRect(x: self.view.bounds.size.width / 2 - 125, y: self.view.bounds.size.height / 2 - 75, width: 250, height: 50))
        payButton.backgroundColor = .green
        payButton.setTitle("goto Pay", for: .normal)
        payButton.addTarget(self, action: #selector(payButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(payButton)
        
        let dismissButton = UIButton(frame: CGRect(x: self.view.bounds.size.width / 2 - 125, y: self.view.bounds.size.height / 2 + 25, width: 250, height: 50))
        dismissButton.backgroundColor = .green
        dismissButton.setTitle("dismiss", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(dismissButton)
        
        if let shoppingCoordinator: ShoppingCoordinator = MicroKernel.findDependency(registerType: ShoppingCoordinator.self) as? ShoppingCoordinator {
            
            shoppingCoordinator.call(request: ShoppingRequest(productId: "1")) { (response: ShoopingResponse?) in
                if let response = response {
                    print("Shopping Price is: \(response.price)")
                }
            }
            
            shoppingCoordinator.call(request: CouponRequest(productId: "1")) { (response: CouponResponse?) in
                if let response = response {
                    print("Shopping Discount is: \(response.discount)")
                }
            }
        }
    }
    
    @objc func payButtonPressed() {
        MicroKernel.open(url: URL(string: "4://")!, options: nil, completionHandler: nil)        
    }
    
    @objc func dismissButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        _ = UIApplication.shared.delegate?.switchOldNavigationController()
    }
}
