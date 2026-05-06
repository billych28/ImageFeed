//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 08.04.2026.
//
import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let imageViewTopMargin: CGFloat = 32
        static let leadingTrailingMargin: CGFloat = 16
        static let margin8: CGFloat = 8
        static let imageViewSize: CGFloat = 70
        static let logoutButtonTrailingMargin: CGFloat = -20
        static let fontSize23: CGFloat = 23
        static let fontSize13: CGFloat = 13
        static let profileImageName = "User avatar stub"
        static let logoutButtonImageSystemName = "ipad.and.arrow.forward"
        static let usernameLabelText = "Екатерина Новикова"
        static let loginLabelText = "@ekaterina_now"
        static let descriptionLabelText = "Hello, world!"
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = configureImageView()
        let usernameLabel = configureUsernameLabel(imageView: imageView)
        let loginLabel = configureLoginLabel(usernameLabel: usernameLabel)
        configureDescriptionLabel(loginLabel: loginLabel)
        configureLogoutButton(imageView: imageView)
    }
    
    // MARK: - Private methods
    private func configureImageView() -> UIView {
        let profileImage = UIImage(named: Constants.profileImageName)
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        imageView.leadingAnchor
            .constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.leadingTrailingMargin
            ).isActive = true
        imageView.topAnchor
            .constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.imageViewTopMargin
            ).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize).isActive = true
        
        return imageView
    }
    
    private func configureLogoutButton(imageView: UIView) {
        let logoutButton = UIButton.systemButton(
            with: UIImage(systemName: Constants.logoutButtonImageSystemName) ?? UIImage(),
            target: self,
            action: nil
        )
        logoutButton.tintColor = .ypRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoutButton)
        
        logoutButton.trailingAnchor
            .constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constants.logoutButtonTrailingMargin
            ).isActive = true
        logoutButton.centerYAnchor
            .constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    private func configureUsernameLabel(imageView: UIView) -> UIView {
        let usernameLabel = UILabel()
        usernameLabel.font = UIFont.systemFont(ofSize: Constants.fontSize23, weight: .bold)
        usernameLabel.textColor = .ypWhite
        usernameLabel.text = Constants.usernameLabelText
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameLabel)
        usernameLabel.leadingAnchor
            .constraint(
                equalTo: imageView.leadingAnchor
            ).isActive = true
        usernameLabel.topAnchor
            .constraint(
                equalTo: imageView.bottomAnchor,
                constant: Constants.margin8
            ).isActive = true
        
        return usernameLabel
    }
    
    private func configureLoginLabel(usernameLabel: UIView) -> UIView {
        let loginLabel = UILabel()
        loginLabel.font = UIFont.systemFont(ofSize: Constants.fontSize13)
        loginLabel.textColor = .ypGray
        loginLabel.text = Constants.loginLabelText
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginLabel)
        loginLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor).isActive = true
        loginLabel.topAnchor
            .constraint(
                equalTo: usernameLabel.bottomAnchor,
                constant: Constants.margin8
            ).isActive = true
        
        return loginLabel
    }
    
    private func configureDescriptionLabel(loginLabel: UIView) {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.fontSize13)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.text = Constants.descriptionLabelText
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor
            .constraint(
                equalTo: loginLabel.bottomAnchor,
                constant: Constants.margin8
            ).isActive = true
    }
    
}
