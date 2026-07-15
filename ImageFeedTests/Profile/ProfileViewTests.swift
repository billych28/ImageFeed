//
//  ProfileViewTests.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.07.2026.
//
@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        // given
        let sut = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        presenter.view = sut
        sut.presenter = presenter
        
        // when
        _ = sut.view
        
        // then
        XCTAssert(presenter.getProfileCalled)
        XCTAssert(presenter.getProfileAvatarURLCalled)
    }
    
    func testViewControllerCallsLogout() {
        // given
        let sut = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        presenter.view = sut
        sut.presenter = presenter
        
        sut.logoutAndNavigateToSplashViewController()
        
        XCTAssert(presenter.logoutCalled)
    }
    
}
