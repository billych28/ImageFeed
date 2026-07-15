//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Мамытов Руслан on 14.07.2026.
//
@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        let presenter = WebViewPresenterSpy()
        sut.presenter = presenter
        presenter.view = sut
        
        // when
        _ = sut.view
        
        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}
