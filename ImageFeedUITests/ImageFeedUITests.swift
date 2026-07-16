//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Мамытов Руслан on 14.07.2026.
//
@testable import ImageFeed
import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        // when
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews[AccessibilityIdentifiers.webViewAccessibilityIdentifier]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("Почта")
        app.buttons["Done"].firstMatch.tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        
        passwordTextField.tap()
        passwordTextField.typeText("Пароль")

        sleep(2)
        app.buttons["Done"].firstMatch.tap()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        // then
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        // given
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons[AccessibilityIdentifiers.likeButtonIdentifier].tap()
        cellToLike.buttons[AccessibilityIdentifiers.likeButtonIdentifier].tap()
        
        sleep(2)
        
        // when
        cellToLike.tap()
        
        sleep(4)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        // then
        let navBackButtonWhiteButton = app.buttons["NavBackButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        // given
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        XCTAssertTrue(app.staticTexts["Имя"].exists)
        XCTAssertTrue(app.staticTexts["@логин"].exists)

        // when
        app.buttons["LogoutButton"].tap()
        
        // then
        app.alerts[AccessibilityIdentifiers.logoutAlertIdentifier].buttons[AccessibilityIdentifiers.logoutAlertYesButtonIdentifier].firstMatch.tap()
    }
    
}
