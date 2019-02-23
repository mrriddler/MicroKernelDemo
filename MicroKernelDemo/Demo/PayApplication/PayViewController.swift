//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit
import MicroKernel

class PayViewController: DemoViewController {
    
    override func viewDidLoad() {
        self.title = "Pay"
        self.view.backgroundColor = UIColor.blue
        
        let navigationDismissButton = UIButton(frame: CGRect(x: self.view.bounds.size.width / 2 - 125, y: self.view.bounds.size.height / 2 - 75, width: 250, height: 50))
        navigationDismissButton.backgroundColor = .green
        navigationDismissButton.setTitle("navigation dismiss", for: .normal)
        navigationDismissButton.addTarget(self, action: #selector(navigationDismissButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(navigationDismissButton)
        
        let viewcontrollerDismissButton = UIButton(frame: CGRect(x: self.view.bounds.size.width / 2 - 125, y: self.view.bounds.size.height / 2 + 25, width: 250, height: 50))
        viewcontrollerDismissButton.backgroundColor = .green
        viewcontrollerDismissButton.setTitle("viewcontroller dismiss", for: .normal)
        viewcontrollerDismissButton.addTarget(self, action: #selector(viewControllerDismissButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(viewcontrollerDismissButton)
        
        self.navigationItem.rightBarButtonItems =
            [UIBarButtonItem(title: "logistics", style: .done, target: self, action: #selector(logisticsButtonPressed)),
             UIBarButtonItem(title: "paySuccess", style: .done, target: self, action: #selector(paySuccessButtonPressed)),
             UIBarButtonItem(title: "payFailure", style: .done, target: self, action: #selector(payFailureButtonPressed))]
    }
    
    @objc func navigationDismissButtonPressed() {
        UIApplication.shared.delegate?.navigationController()?.dismiss(animated: true, completion: nil)
        _ = UIApplication.shared.delegate?.switchOldNavigationController()
    }
    
    @objc func viewControllerDismissButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        _ = UIApplication.shared.delegate?.switchOldNavigationController()
    }
    
    @objc func logisticsButtonPressed() {
        MicroKernel.open(url: URL(string: "5://")!, options: [MicroApplicationLaunchOptionsKey(rawValue: "presentByNav"): "presentByNav"], completionHandler: nil)
    }
    
    @objc func paySuccessButtonPressed() {
        MicroKernel.post(eventName: "Pay", eventType: PaySuccessCoordinatorEvent.self, event: PaySuccessCoordinatorEvent(price: "1000"))
        MicroKernel.post(eventName: "Coupon", eventType: CouponCoordinatorEvent.self, event: CouponCoordinatorEvent(discount: "0.3"))
        MicroKernel.post(eventName: "Pay")
    }
    
    @objc func payFailureButtonPressed() {
        MicroKernel.post(eventName: "Pay", eventType: PayFailureCoordinatorEvent.self, event: PayFailureCoordinatorEvent(comment: "TooExpensive"))
    }
}
