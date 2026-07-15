//
//  ImagesListTests.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.07.2026.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        sut.presenter = presenter
        presenter.view = sut
        
        // when
        _ = sut.view
        
        // then
        XCTAssert(presenter.fetchNextPageCalled)
    }
}
