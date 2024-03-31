#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif


class ModalViewController: UIViewController {
    static let dismissText = "Dismiss view controller"
    static let presentText = "Present view controller"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemOrange

        let dismissButton = createButton(withTitle: Self.dismissText,
                                         action: #selector(dismissViewController))
        let presentModalButton = createButton(withTitle: Self.presentText,
                                              action: #selector(presentViewController))

        let stackView = UIStackView(arrangedSubviews: [dismissButton, presentModalButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        stackView.axis = .vertical

        view.addSubview(stackView)
        let padding: CGFloat = 20  // Define the amount of padding

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            stackView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }

    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    @objc private func presentViewController() {
        present(NestedModalViewController(), animated: true)
    }

    private func createButton(withTitle title: String, 
                              action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, 
                        for: .normal)
        button.addTarget(self, 
                         action: action,
                         for: .touchUpInside)

        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

        return button
    }
}
