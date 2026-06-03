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
    static let alertTitle = "Ошибка"
    static let alertButtonTitle = "Ок"
    static let invalidRequestErrorDescription = "Неверно сформированный запрос"
    static let unknownErrorDescription = "Произошла неизвестная ошибка"
    static let decodingErrorDescription = "Произошла ошибка при получении ответа с сервера"
    static let httpStatusCodeErrorDescription = "Сервер вернул ответ с ошибкой: "
}

final class AuthViewController: UIViewController {
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
    
    func handleError(_ error: any Error) {
        let errorMessage = switch error {
        case NetworkError.invalidRequest:
            Constants.invalidRequestErrorDescription
        case NetworkError.urlSessionError:
            Constants.unknownErrorDescription
        case NetworkError.decodingError(_):
            Constants.decodingErrorDescription
        case NetworkError.httpStatusCode(let code):
            Constants.httpStatusCodeErrorDescription + String(code)
        default:
            Constants.unknownErrorDescription
        }
        
        print(error.localizedDescription)
        showErrorAlert(message: errorMessage)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: Constants.alertTitle,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: Constants.alertButtonTitle,
            style: .default)

        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
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
