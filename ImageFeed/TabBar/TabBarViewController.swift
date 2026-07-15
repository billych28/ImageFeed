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
        
        guard let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else {
            return
        }
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .profileTabInactive),
            selectedImage: UIImage(resource: .profileTabActive)
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
