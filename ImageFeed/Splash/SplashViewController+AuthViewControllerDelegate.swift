//
//  SplashViewController+AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 27.05.2026.
//
import UIKit

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        switchToTabBarController()
    }
}
