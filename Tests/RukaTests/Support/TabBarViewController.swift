#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif


class TabBarViewController: UITabBarController {

    public let secondTabViewController = SecondTabViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let root = RootViewController()
        viewControllers = [root,
                           UINavigationController(rootViewController: secondTabViewController)]
    }
}
