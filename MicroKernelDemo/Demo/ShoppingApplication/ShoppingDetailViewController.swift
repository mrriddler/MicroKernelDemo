//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit
import MicroKernel

class ShoppingDetailViewController: DemoViewController {
    
    override func viewDidLoad() {
        self.title = "ShoppingDetail"
        self.view.backgroundColor = UIColor.orange
        
        let popButton = UIButton(frame: CGRect(x: self.view.bounds.size.width / 2 - 125, y: self.view.bounds.size.height / 2 - 75, width: 250, height: 50))
        popButton.backgroundColor = .green
        popButton.setTitle("pop to Feed", for: .normal)
        popButton.addTarget(self, action: #selector(popButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(popButton)
        
        let resetButton = UIButton(frame: CGRect(x: self.view.bounds.size.width / 2 - 125, y: self.view.bounds.size.height / 2 + 25, width: 250, height: 50))
        resetButton.backgroundColor = .green
        resetButton.setTitle("reset to Feed", for: .normal)
        resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(resetButton)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "chat", style: .done, target: self, action: #selector(chatButtonPressed))
        
        if let shareService: ShareService = MicroKernel.findDependency(registerType: ShareService.self) as? ShareService {
            print("Share to \(shareService.share())")
        }
        
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
    
    @objc func popButtonPressed() {
        _ = UIApplication.shared.delegate?.navigationController()?.popToRootViewController(animated: true)
    }
    
    @objc func resetButtonPressed() {
        var resetVC: [UIViewController] = UIApplication.shared.delegate!.navigationController()!.viewControllers
        if resetVC.count >= 2 {
            resetVC.removeLast()
            resetVC.removeLast()
            _ = UIApplication.shared.delegate?.navigationController()?.setViewControllers(resetVC, animated: true)
        }
    }
    
    @objc func chatButtonPressed() {
        MicroKernel.open(url: URL(string: "3://")!, options: [MicroApplicationLaunchOptionsKey(rawValue: "presentByNav"): "presentByNav"], completionHandler: nil)
    }
}

