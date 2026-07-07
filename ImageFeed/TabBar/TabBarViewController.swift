//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 15.06.2026.
//
import UIKit

final class TabBarViewController: UITabBarController {
    // MARK: - Public methods
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        let profileViewController = ProfileViewController()
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .profileTabInactive),
            selectedImage: UIImage(resource: .profileTabActive)
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
