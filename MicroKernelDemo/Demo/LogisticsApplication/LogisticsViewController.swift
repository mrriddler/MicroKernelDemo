//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit

class LogisticsViewController: DemoViewController {
    
    override func viewDidLoad() {
        self.title = "Logistics"
        self.view.backgroundColor = UIColor.brown
        
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
    }
    
    @objc func navigationDismissButtonPressed() {
        UIApplication.shared.delegate?.navigationController()?.dismiss(animated: true, completion: nil)
        _ = UIApplication.shared.delegate?.switchOldNavigationController()
    }
    
    @objc func viewControllerDismissButtonPressed() {
        self.dismiss(animated: true, completion: nil)
        _ = UIApplication.shared.delegate?.switchOldNavigationController()
    }
}
