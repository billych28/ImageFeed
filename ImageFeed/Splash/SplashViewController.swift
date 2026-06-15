//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 27.05.2026.
//
import UIKit
import SwiftKeychainWrapper

final class SplashViewController: UIViewController, ErrorHandler {
    // MARK: - IBOutlets
    private let splashImageView = UIImageView()
    
    // MARK: - Private properties
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let storage = OAuth2Storage.shared

    // MARK: - Public properties
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupView()
        checkStorageTokenAndNavigate()
    }
    
    // MARK: - Public methods
    func switchToTabBarController() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
        else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    // MARK: - Private methods
    private func setupView() {
        splashImageView.image = UIImage(named: "Practicum")
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(splashImageView)
        
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func checkStorageTokenAndNavigate() {
        if let token = storage.token {
            fetchProfile(token: token)
        } else {
            createAuthVCAndPresent()
        }
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImageURL(username: profile.username) { _ in }
                self.switchToTabBarController()
            case .failure(let error):
                handleError(controller: self, error: error)
            }
        }
    }
    
    private func createAuthVCAndPresent() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            assertionFailure("Не удалось найти AuthViewController по идентификатору")
            return
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen

        present(authViewController, animated: true)
    }
}
