import Ruka
import XCTest
import os.log

class Tests: XCTestCase {
    weak var window: UIWindow!
    var app: App!
    let logger = Logger(subsystem: "App", category: "App")

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        executionTimeAllowance = 1
        getCurrentWindow()
        self.window.rootViewController = nil
        waitForAnimationsToFinish(window: window)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.app = nil
        self.window.rootViewController = nil
    }

    func waitABit() {
        let expectation = XCTestExpectation(description: "Wait for x seconds")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1) // Add a buffer to the timeout to ensure it doesn't expire too early
    }

    private func getCurrentWindow() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        window = scene.windows.first(where: { $0.isKeyWindow })
   }

    func checkWindow() {
        XCTAssertNotNil(self.window,
                        "tests need a window")
    }

    func givenRootVC() {
        checkWindow()
        let controller = RootViewController()
        app = App(window: window,
                  controller: controller)
    }

    func givenRootVCInNavC() {
        checkWindow()
        let navigationController = UINavigationController(rootViewController: RootViewController())
        app = App(window: window,
                  controller: navigationController)
    }

    func givenFormVC() {
        checkWindow()
        let controller = FormViewController()
        app = App(window: window,
                  controller: controller)
    }

    func givenTabBarVC() {
        checkWindow()
        let controller = TabBarViewController()
        app = App(window: window,
                  controller: controller)
    }

    func givenTableVC() {
        checkWindow()
        let controller = TableViewController()
        app = App(window: window,
                  controller: controller)
    }

    // MARK: Storyboard

    func test_findsAStoryboardBackedController() throws {
        // It's impossible to add a storyboard to a test target.
    }

    // MARK: UILabel

    func test_findsALabel() throws {
        givenRootVC()
        let label = try window.label(RootViewController.labelText)
        XCTAssertNotNil(label)
        XCTAssertEqual(label?.superview?.superview, app.controller.view)
    }

    func test_findsALabelViaTheAccessibilityLabel() throws {
        givenRootVC()
        XCTAssertNotNil(try window.label(RootViewController.labelA11yText))
    }

    func test_findsALabelViaTheAccessibilityIdentifier() throws {
        givenRootVC()
        XCTAssertNotNil(try window.label(RootViewController.labelA11yIdentified))
    }

    func test_doesNotFindAHiddenLabel() throws {
        givenRootVC()
        XCTAssertNil(try window.label(RootViewController.labelHiddenText,
                                      failureBehavior: .doNothing))
    }

    func test_doesNotFindALabelOffTheScreen() throws {
        givenRootVC()
        XCTAssertNil(try window.label(RootViewController.labelOffScreen,
                                      failureBehavior: .doNothing))
    }

    // MARK: UIButton

    func test_findsAButton() throws {
        givenRootVC()
        let button = try window.button(RootViewController.buttonTitle)
        XCTAssertNotNil(button)
        XCTAssertEqual(button?.superview?.superview, app.controller.view)
    }

    func test_findsAButtonViaTheAccessibilityLabel() throws {
        givenRootVC()
        XCTAssertNotNil(try window.button("a11y labeled button"))
    }

    func test_findsAButtonViaTheAccessibilityIdentifier() throws {
        givenRootVC()
        XCTAssertNotNil(try window.button("a11y identified button"))
    }

    func test_doesNotFindAHiddenButton() throws {
        givenRootVC()

        XCTAssertNil(try window.button(RootViewController.buttonTitleHidden,
                                       failureBehavior: .doNothing))
    }

    func test_doesNotFindAButtonOffTheScreen() throws {
        givenRootVC()
        XCTAssertNil(try window.button(RootViewController.offScreenButtonTitle,
                                       failureBehavior: .doNothing))
    }

    func test_tapsAButton() throws {
        givenRootVC()

        try window.tapButton(title: RootViewController.buttonTitle)

        _ = try window.label(RootViewController.labelTextChanged)
    }

    func test_doesNotTapADisabledButton() throws {
        givenRootVC()

        try window.tapButton(title: RootViewController.disabledButtonTitle,
                             tappable: false)

        XCTAssertNil(try window.label(RootViewController.labelTextChanged,
                                      failureBehavior: .doNothing))
    }

    // MARK: UINavigationController

    func test_pushesAViewController() throws {
        givenRootVCInNavC()

        try window.tapButton(title: RootViewController.pushText)

        XCTAssertEqual((app.controller as? UINavigationController)?.viewControllers.count, 2)
    }

    func test_popsAViewController() throws {
        givenRootVCInNavC()

        try window.tapButton(title: RootViewController.pushText)
        waitForAnimationsToFinish(window: window)
        XCTAssertEqual((app.controller as? UINavigationController)?.viewControllers.count, 2)

        try window.tapButton(title: RootViewController.popText)
        waitForAnimationsToFinish(window: window)
        XCTAssertEqual((app.controller as? UINavigationController)?.viewControllers.count, 1)
    }

    // MARK: Modal view controllers

    func test_presentsAViewController() throws {
        givenRootVC()

        try window.tapButton(title: RootViewController.presentText)

        XCTAssertNotNil(app.controller.presentedViewController)
    }

    func test_dismissesAViewController() throws {
        givenRootVC()
        // check missing button dismiss
        XCTAssertNil(try window.button(ModalViewController.dismissText,
                                       failureBehavior: .doNothing))
        // tap present button
        try window.tapButton(title: RootViewController.presentText)

        waitForAnimationsToFinish(window: window)

        // check visible button dismiss
        XCTAssertNotNil(try window.button(ModalViewController.dismissText,
                                          failureBehavior: .doNothing))
        // tap dismiss button
        try window.tapButton(title: ModalViewController.dismissText)

        waitForAnimationsToFinish(window: window)

        // check missing button dismiss
        XCTAssertNil(try window.button(ModalViewController.dismissText,
                                       failureBehavior: .doNothing))
    }

    func test_dismissNestedModalViewController() throws {
        givenRootVC()
        XCTAssertNil(try window.button(ModalViewController.dismissText,
                                       failureBehavior: .doNothing))

        try window.tapButton(title: ModalViewController.presentText)
        waitForAnimationsToFinish(window: window)
        XCTAssertNotNil(try window.button(ModalViewController.dismissText,
                                          failureBehavior: .doNothing))

        try window.tapButton(title: ModalViewController.presentText)
        waitForAnimationsToFinish(window: window)
        XCTAssertNotNil(try window.button(NestedModalViewController.dismissText,
                                          failureBehavior: .doNothing))

        try window.tapButton(title: NestedModalViewController.dismissText)
        waitForAnimationsToFinish(window: window)
        XCTAssertNotNil(try window.button(ModalViewController.dismissText,
                                          failureBehavior: .doNothing))

        try window.tapButton(title: ModalViewController.dismissText)
        waitForAnimationsToFinish(window: window)
        XCTAssertNil(try window.button(ModalViewController.dismissText,
                                       failureBehavior: .doNothing))
    }

    // MARK: UITabBarController

    func test_presentsAViewControllerOnSecondTabInTabBarController() throws {
        givenTabBarVC()
        XCTAssertNil(try window.button(SecondTabViewController.presentText,
                                       failureBehavior: .doNothing))

        (app.controller as? UITabBarController)?.selectedIndex = 1
        waitFor {
            let controller = (app.controller as? TabBarViewController)?.secondTabViewController
            return controller?.isVisible ?? true
        }
        waitForAnimationsToFinish(window: window)
        XCTAssertNotNil(try window.button(SecondTabViewController.presentText,
                                          failureBehavior: .doNothing))
        try window.tapButton(title: SecondTabViewController.presentText)
        XCTAssertNotNil((app.controller as? TabBarViewController)?.secondTabViewController.presentedViewController)
    }

    // MARK: UIAlertController

    func test_findsAnAlert() throws {
        givenRootVC()

        try window.tapButton(title: RootViewController.alertText)
        XCTAssertNotNil(try window.label("Alert title"))
        XCTAssertNotNil(try window.label("Alert message."))
    }

    func test_dismissesAnAlert() throws {
        givenRootVC()
        try window.tapButton(title: RootViewController.alertText)
        XCTAssertNil(try window.button(RootViewController.alertText,
                                       failureBehavior: .doNothing))

        app.alertViewController?.tapButton(title: "Dismiss")
        waitForAnimationsToFinish(window: window)
        XCTAssertNotNil(try window.button(RootViewController.alertText,
                                          failureBehavior: .doNothing))
        XCTAssertNotNil(try window.label(RootViewController.labelTextChanged,
                                         failureBehavior: .doNothing))
    }

    // MARK: UITableView

    func test_findsVisibleCells() throws {
        givenTableVC()
        XCTAssertEqual(app.tableView?.visibleCells.count ?? 0, 3)
    }

    func test_findsASpecificCell() throws {
        givenTableVC()
        XCTAssertNotNil(try app.tableView?.cell(containingText: "Three"))
        XCTAssertNotNil(try window.label(RootViewController.labelText,
                                         failureBehavior: .doNothing))

        XCTAssertNil(try app.tableView?.cell(containingText: TableViewController.labelText,
                                             failureBehavior: .doNothing))
    }

    func test_tapsACell() throws {
        givenTableVC()
        try app.tableView?.cell(containingText: "Three")?.tap()
        XCTAssertNotNil(try window.label(RootViewController.labelTextChanged))
    }

    // MARK: UISwitch

#if !os(tvOS)
    func test_findsASwitchViaTheAccessibilityLabel() throws {
        givenFormVC()
        XCTAssertNotNil(try window.switch("a11y labeled switch"))
    }

    func test_findsASwitchViaTheAccessibilityIdentifier() throws {
        givenFormVC()
        XCTAssertNotNil(try window.switch("a11y identified switch"))
    }

    func test_doesNotFindAHiddenSwitch() throws {
        givenFormVC()
        XCTAssertNil(try window.switch(FormViewController.switchA11yLabelHiddenText,
                                       failureBehavior: .doNothing))
    }

    func test_doesNotFindASwitchOffTheScreen() throws {
        givenFormVC()
        XCTAssertNil(try window.switch("An off screen switch",
                                       failureBehavior: .doNothing))
    }

    func test_togglesASwitch() throws {
        givenFormVC()
        let Aswitch = try window.switch(FormViewController.switchA11yLabelText)
        XCTAssertNotNil(try window.label(FormViewController.switchLabelDisabledText))

        Aswitch?.toggle()
        XCTAssertNotNil(try window.label(FormViewController.switchLabelEnabledText))
    }

    func test_doesNotToggleADisabledSwitch() throws {
        givenFormVC()

        let Aswitch = try window.switch(FormViewController.switchA11yLabelDisabledText)
        XCTAssertNotNil(try window.label(FormViewController.switchLabelDisabledText))

        Aswitch?.toggle()
        XCTAssertNotNil(try window.label(FormViewController.switchLabelDisabledText))
    }
    // MARK: UIStepper

    func test_findsAStepperViaTheAccessibilityLabel() throws {
        givenFormVC()
        XCTAssertNotNil(try window.stepper("a11y labeled stepper"))
    }

    func test_findsAStepperViaTheAccessibilityIdentifier() throws {
        givenFormVC()
        XCTAssertNotNil(try window.stepper("a11y identified stepper"))
    }

    func test_doesNotFindAHiddenStepper() throws {
        givenFormVC()
        XCTAssertNil(try window.stepper("A hidden stepper",
                                        failureBehavior: .doNothing))
    }

    func test_doesNotFindAStepperOffTheScreen() throws {
        givenFormVC()
        XCTAssertNil(try window.stepper("An off screen stepper",
                                        failureBehavior: .doNothing))
    }

    func test_incrementsAStepper() throws {
        givenFormVC()
        try window.stepper("A stepper")?.increment()
        XCTAssertNotNil(try window.label("3.0"))
    }

    func test_decrementsAStepper() throws {
        givenFormVC()
        try window.stepper("A stepper")?.decrement()
        XCTAssertNotNil(try window.label("1.0"))
    }

    func test_doesNotIncrementADisabledStepper() throws {
        givenFormVC()
        try window.stepper("A disabled stepper")?.increment()
        XCTAssertNotNil(try window.label("2.0"))
    }

    func test_doesNotDecrementADisabledStepper() throws {
        givenFormVC()
        try window.stepper("A disabled stepper")?.decrement()
        XCTAssertNotNil(try window.label("2.0"))
    }

    // MARK: UISlider

    func test_findsASliderViaTheAccessibilityLabel() throws {
        givenFormVC()
        XCTAssertNotNil(try window.slider("a11y labeled slider"))
    }

    func test_findsASliderViaTheAccessibilityIdentifier() throws {
        givenFormVC()
        XCTAssertNotNil(try window.slider("a11y identified slider"))
    }

    func test_doesNotFindAHiddenSlider() throws {
        givenFormVC()
        XCTAssertNil(try window.slider("A hidden slider",
                                       failureBehavior: .doNothing))
    }

    func test_doesNotFindASliderOffTheScreen() throws {
        givenFormVC()
        XCTAssertNil(try window.slider("An off screen slider",
                                       failureBehavior: .doNothing))
    }

    func test_setsASlidersValue() throws {
        givenFormVC()
        try window.slider("A slider")?.set(value: 30)
        XCTAssertNotNil(try window.label("30.0"))
    }

    func test_doesNotSetADisabledSlidersValue() throws {
        givenFormVC()
        try window.slider("A disabled slider")?.set(value: 30)
        XCTAssertNotNil(try window.label("20.0"))
    }
#endif

    // MARK: UITextField

    func test_findsATextFieldViaThePlaceholder() throws {
        givenFormVC()
        XCTAssertNotNil(try window.textField("Text field placeholder"))
    }

    func test_findsATextFieldViaTheAccessibilityLabel() throws {
        givenFormVC()
        XCTAssertNotNil(try window.textField("a11y labeled text field"))
    }

    func test_findsATextFieldViaTheAccessibilityIdentifier() throws {
        givenFormVC()
        XCTAssertNotNil(try window.textField("a11y identified text field"))
    }

    func test_doesNotFindAHiddenTextField() throws {
        givenFormVC()
        XCTAssertNil(try window.textField("Hidden text field placeholder",
                                          failureBehavior: .doNothing))
    }

    func test_doesNotFindATextFieldOffTheScreen() throws {
        givenFormVC()
        XCTAssertNil(try window.textField("Off screen text field placeholder",
                                          failureBehavior: .doNothing))
    }

    func test_typesIntoATextField() throws {
        givenFormVC()
        let textField = try window.textField("Text field placeholder")

        textField?.type(text: "Some typed text.")
        XCTAssertEqual(textField?.text, "Some typed text.")
        XCTAssertNotNil(try window.label("Some typed text."))
    }

    func test_doesNotTypeIntoADisabledTextField() throws {
        givenFormVC()
        let textField = try window.textField("Disabled text field placeholder",
                                             failureBehavior: .doNothing)

        textField?.type(text: "Some typed text.")
        XCTAssertEqual(textField?.text, "")
        XCTAssertNil(try window.label("Some typed text.",
                                      failureBehavior: .doNothing))
    }

    // MARK: Failure behavior

    func test_aMissingElement_raisesAnError() throws {
        givenRootVC()
        XCTAssertThrowsError(try window.label("Missing element",
                                              failureBehavior: .raiseException))
    }
    
    func test_aMissingElement_isNil() throws {
        givenRootVC()
        XCTAssertNil(try window.label("Missing element",
                                      failureBehavior: .doNothing))
    }

    func test_aMissingElement_fails() throws {
        givenRootVC()
        let options = XCTExpectedFailure.Options()
        options.issueMatcher = { issue in
            issue.type == .assertionFailure &&
            issue.compactDescription.contains("Could not find view with")
        }
        XCTExpectFailure("This test is expected to fail.", options: options)
        XCTAssertNil(try window.label("Missing element"))
    }
}
