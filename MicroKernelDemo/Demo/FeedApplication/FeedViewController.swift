//      __  ____                 __ __                     __
//     /  |/  (_)_____________  / //_/__  _________  ___  / /
//    / /|_/ / / ___/ ___/ __ \/ ,< / _ \/ ___/ __ \/ _ \/ /
//   / /  / / / /__/ /  / /_/ / /| /  __/ /  / / / /  __/ /
//  /_/  /_/_/\___/_/   \____/_/ |_\___/_/  /_/ /_/\___/_/
//

import UIKit
import MicroKernel

class FeedViewController: DemoViewController {
    
    override func viewDidLoad() {
        self.title = "Feed"
        self.view.backgroundColor = UIColor.cyan
        
        let button = UIButton(frame: CGRect(x: self.view.bounds.size.width / 2 - 125, y: self.view.bounds.size.height / 2 - 25, width: 250, height: 50))
        button.backgroundColor = .green
        button.setTitle("goto Shopping", for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        if let shareService: ShareService = MicroKernel.findDependency(registerType: ShareService.self) as? ShareService {
            print("Share to \(shareService.share())")
        }
    }
    
    @objc func buttonPressed() {
        MicroKernel.open(url: URL(string: "2://")!, options: nil, completionHandler: nil)
    }
}
