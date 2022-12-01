#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif


class RootViewController: UIViewController {
    static let labelText = "Label text"
    static let labelHiddenText = "Hidden label text"
    static let labelA11yText = "a11y labeled label"
    static let labelA11yIdentified = "a11y identified label"
    static let labelOffScreen =  "Off screen label text"
    static let buttonTitle = "Button title"
    static let buttonTitleHidden = "Hidden button title"
    static let disableButtonTitle = "Disabled button title"
    static let labelTextChanged = "Changed label text"

    static let offScreenButtonTitle = "Off screen button title"

    private let label = UILabel()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        installStackView()
        installSubviews()
    }

    private func installStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: stackView.topAnchor),
        ])
    }

    private func installSubviews() {
        installLabels()
        installButtons()
    }

    private func installLabels() {
        label.text = RootViewController.labelText
        stackView.addArrangedSubview(label)
        _ = addLabel(text: RootViewController.labelHiddenText, isHidden: true)

        let a11yLabeledLabel = addLabel(text: "")
        a11yLabeledLabel.accessibilityLabel = RootViewController.labelA11yText

        let a11yIdentifiedLabel = addLabel(text: "")
        a11yIdentifiedLabel.accessibilityIdentifier = RootViewController.labelA11yIdentified

        let offScreenLabel = UILabel()
        offScreenLabel.text = RootViewController.labelOffScreen
        view.addSubview(offScreenLabel)
        offScreenLabel.frame.origin.y = -100
    }

    private func installButtons() {
        _ = addButton(title: RootViewController.buttonTitle)
        _ = addButton(title: RootViewController.buttonTitleHidden, isHidden: true)
        _ = addButton(title: RootViewController.disableButtonTitle, isEnabled: false)

        _ = addButton(title: "Push view controller", action: #selector(pushViewController))
        _ = addButton(title: "Pop view controller", action: #selector(popViewController))
        _ = addButton(title: "Present view controller", action: #selector(presentViewController))

        _ = addButton(title: "Show alert", action: #selector(showAlert))

        let a11yLabeledButton = addButton(title: "")
        a11yLabeledButton.accessibilityLabel = "a11y labeled button"

        let a11yIdentifiedButton = addButton(title: "")
        a11yIdentifiedButton.accessibilityIdentifier = "a11y identified button"

        let offScreenButton = UIButton()
        offScreenButton.setTitle(RootViewController.offScreenButtonTitle, for: .normal)
        view.addSubview(offScreenButton)
        offScreenButton.frame.origin.y = -100
    }

    private func addLabel(text: String, isHidden: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.isHidden = isHidden
        stackView.addArrangedSubview(label)
        return label
    }

    private func addButton(title: String, isHidden: Bool = false, isEnabled: Bool = true, action: Selector = #selector(changeLabelText)) -> UIButton {
        let button = UIButton(type: .system)
        button.isHidden = isHidden
        button.isEnabled = isEnabled
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        stackView.addArrangedSubview(button)
        return button
    }

    @objc private func changeLabelText() {
        label.text = RootViewController.labelTextChanged
    }

    @objc private func pushViewController() {
        navigationController?.pushViewController(RootViewController(), animated: true)
    }

    @objc private func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func presentViewController() {
        present(ModalViewController(), animated: true)
    }

    @objc private func showAlert() {
        let alert = UIAlertController(title: "Alert title", message: "Alert message.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { [weak self] _ in
            self?.label.text = RootViewController.labelTextChanged
        }))
        present(alert, animated: true)
    }
}
