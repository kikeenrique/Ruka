#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif


class NestedModalViewController: UIViewController {
    static let dismissText = "Dismiss view controller nest"

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBrown

        let button = UIButton(type: .system)
        button.setTitle(Self.dismissText, for: .normal)
        button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

        button.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }

    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
}
