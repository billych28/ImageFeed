//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.05.2026.
//
import UIKit

// MARK: - Constants
private enum Constants {
    static let showWebViewSegueIdentifier = "ShowWebView"
}

final class AuthViewController: UIViewController, ErrorHandler {
    // MARK: - Public properties
    let oauth2Service = OAuth2Service.shared
    let oauth2Storage = OAuth2Storage.shared
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    // MARK: - Public methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.showWebViewSegueIdentifier:
            guard let viewController = segue.destination as? WebViewController else {
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            viewController.presenter = webViewPresenter
            webViewPresenter.view = viewController
            viewController.delegate = self
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private methods
    private func configureBackButton() {
        let backIndicatorImage = UIImage(resource: .backward)
        navigationController?.navigationBar.backIndicatorImage = backIndicatorImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backIndicatorImage
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem?.tintColor = UIColor(resource: .ypBlack)
    }
}
