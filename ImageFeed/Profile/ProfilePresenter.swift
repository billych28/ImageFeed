//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.07.2026.
//
import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func getProfile()
    func getProfileAvatarURL() -> URL?
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let logoutService = ProfileLogoutService.shared
    
    func getProfile() {
        if let profile = profileService.profile {
            view?.updateProfile(with: profile)
        }
    }
    
    func getProfileAvatarURL() -> URL? {
        return if let url = profileImageService.avatarURL {
            URL(string: url)
        } else {
            nil
        }
    }
    
    func logout() {
        logoutService.logout()
    }
}
