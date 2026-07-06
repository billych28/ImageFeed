//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 14.05.2026.
//
import UIKit

// MARK: - Constants
private enum Constants {
    static let backImageName = "Backward"
    static let ypBlackColor = "ypBlack"
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
        case GlobalConstants.showWebViewSegueIdentifier:
            guard let viewController = segue.destination as? WebViewController else {
                return
            }
            viewController.delegate = self
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private methods
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(
            named: Constants.backImageName
        )
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(
            named: Constants.backImageName
        )
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem?.tintColor = UIColor(
            named: Constants.ypBlackColor
        )
    }
}
