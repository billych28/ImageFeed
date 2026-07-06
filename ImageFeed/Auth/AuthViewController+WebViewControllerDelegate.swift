//
//  AuthViewController+WebViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 27.05.2026.
//
import UIKit

extension AuthViewController: WebViewControllerDelegate {    
    func webViewController(
        _ vc: WebViewController,
        didAuthenticateWithCode code: String
    ) {
        vc.navigationController?.popViewController(animated: true)
        
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let token):
                self.oauth2Storage.token = token
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                handleError(controller: self, error: error)
            }
            
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func webViewControllerDidCancel(_ vc: WebViewController) {
        dismiss(animated: true)
    }
}
