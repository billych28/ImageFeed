//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.07.2026.
//
@testable import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var getProfileCalled  = false
    var getProfileAvatarURLCalled = false
    var logoutCalled = false
    
    func getProfile() {
        getProfileCalled = true
    }
    
    func getProfileAvatarURL() -> URL? {
        getProfileAvatarURLCalled = true
        return nil
    }
    
    func logout() {
        logoutCalled = true
    }

}
