//
//  SocialLean_ExampleUITests.swift
//  SocialLean_ExampleUITests
//
//  Created by Alan Ostanik on 01/03/2021.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest

class SocialLeanExampleUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {

        continueAfterFailure = false
        app.launch()
    }

    func testLoginFacebook() throws {

        app.launch()
        app.buttons["Continue with Facebook"].tap()

        app.webViews.staticTexts["Accept All"]
            .tapWhenExists(timeout: 5)

        app.webViews.textFields["Mobile number or email"]
            .typeWhenExists("vpvihmwiro_1614700911@tfbnw.net", timeout: 0.5)

        app.webViews.secureTextFields["Facebook Password"]
            .typeWhenExists("*xJkou2xpKwd4b$&BdXSk&sNgG7MrE", timeout: 0.5)

        app.webViews.buttons["Log In"]
            .tapWhenExists(timeout: 0.5)

        [app.webViews.buttons["Continue as Jackson"], app.webViews.buttons["Continue"]]
            .waitForFirst(timeout: 10)?
            .tap()

        guard app.staticTexts["You Logged with: Facebook"].waitForExistence(timeout: 10) else {
            return XCTFail("Unable to login")
        }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCUIElement {

    func typeWhenExists(_ text: String, timeout: Double) {

        self.tapWhenExists(timeout: timeout)
        self.typeText(text)
    }

    func tapWhenExists(timeout: Double) {
        guard self.waitForExistence(timeout: timeout) else {
            return XCTFail("Unable to find element: \(self.description)")
        }
        self.tap()
    }
}

extension Array where Element == XCUIElement {

    func waitForFirst(timeout: Double) -> XCUIElement? {
        for element in self {
            if element.waitForExistence(timeout: timeout) {
                return element
            }
        }
        return nil
    }
}
