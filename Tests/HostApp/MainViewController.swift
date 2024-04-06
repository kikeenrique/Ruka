#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif


class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray

        let subview = UIView()
        subview.backgroundColor = .red
        subview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subview)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            subview.topAnchor.constraint(equalTo: safeArea.topAnchor),
            subview.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}
