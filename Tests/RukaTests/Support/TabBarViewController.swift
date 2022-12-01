#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif


class TabBarViewController: UITabBarController {

    let secondTabViewController = SecondTabViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [RootViewController(), UINavigationController(rootViewController: secondTabViewController)]
    }
}
