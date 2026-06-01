//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 27.05.2026.
//
import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Public properties
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Private properties
    private let storage = OAuth2Storage.shared
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    private func checkStorageTokenAndNavigate() {
        if storage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(
                withIdentifier: GlobalConstants.showAuthenticationSegueIdentifier,
                sender: nil
            )
        }
    }
}
