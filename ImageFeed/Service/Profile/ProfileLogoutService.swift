//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 01.07.2026.
//
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private let storage = OAuth2Storage.shared
    private let imagesListService = ImagesListService.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private init() {}
    
    func logout() {
        cleanCookies()
        clearUserData()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func clearUserData() {
        storage.token = nil
        profileService.clearProfile()
        profileImageService.clearAvatar()
    }
}
