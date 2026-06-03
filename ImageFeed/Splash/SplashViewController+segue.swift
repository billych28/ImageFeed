//
//  SplashViewController+segue.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 27.05.2026.
//
import UIKit

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == GlobalConstants.showAuthenticationSegueIdentifier else {
            super.prepare(for: segue, sender: sender)
            return
        }
        
        guard
            let navigationController = segue.destination as? UINavigationController,
            let viewController = navigationController.viewControllers.first as? AuthViewController
        else {
            assertionFailure(
                "Failed to prepare for \(GlobalConstants.showAuthenticationSegueIdentifier)"
            )
            return
        }
            
        viewController.delegate = self
    }
}
