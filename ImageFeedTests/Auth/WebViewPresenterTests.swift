//
//  WebViewPresenterTests.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.07.2026.
//

@testable import ImageFeed
import XCTest

final class WebViewPresenterTests: XCTestCase {
    
    func testPresenterCallsLoadRequest() {
        // given
        let viewController = WebViewControllerSpy()
        let authHelper = AuthHelper()
        let sut = WebViewPresenter(authHelper: authHelper)
        sut.view = viewController
        
        // when
        sut.viewDidLoad()
        
        // then
        XCTAssert(viewController.didLoadCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let sut = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = sut.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressVisibleWhenOne() {
        //given
        let authHelper = AuthHelper()
        let sut = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        //when
        let shouldHideProgress = sut.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
}
