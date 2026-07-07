//
//  ErrorHandler.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 10.06.2026.
//
import UIKit

// MARK: - Constants
private enum Constants {
    static let alertTitle = "Что-то пошло не так("
    static let alertButtonTitle = "Ок"
    static let invalidRequestErrorDescription = "Неверно сформированный запрос"
    static let unknownErrorDescription = "Произошла неизвестная ошибка"
    static let decodingErrorDescription = "Произошла ошибка при получении ответа с сервера"
    static let httpStatusCodeErrorDescription = "Сервер вернул ответ с ошибкой: "
    static let authErrorDescription = "Не удалось войти в систему"
}

protocol ErrorHandler {
    func handleError(controller vc: UIViewController, error: any Error)
}

extension ErrorHandler {
    func handleError(controller vc: UIViewController, error: any Error) {
        let alertMessage = switch error {
        case NetworkError.invalidRequest:
            Constants.invalidRequestErrorDescription
        case NetworkError.urlSessionError:
            Constants.unknownErrorDescription
        case NetworkError.decodingError(_):
            Constants.decodingErrorDescription
        case NetworkError.httpStatusCode(let code):
            Constants.httpStatusCodeErrorDescription + String(code)
        case AuthError.authError:
            Constants.authErrorDescription
        default:
            Constants.unknownErrorDescription
        }
        
        showErrorAlert(controller: vc, message: alertMessage)

        print(error.localizedDescription)
    }
    
    private func showErrorAlert(
        controller vc: UIViewController,
        message: String
    ) {
        let alert = UIAlertController(
            title: Constants.alertTitle,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: Constants.alertButtonTitle,
            style: .default)

        alert.addAction(action)

        vc.present(alert, animated: true, completion: nil)
    }
}
