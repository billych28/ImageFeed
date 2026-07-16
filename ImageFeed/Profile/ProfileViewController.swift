//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 08.04.2026.
//
import UIKit
import Kingfisher

// MARK: - Constants
private enum Constants {
    static let backgroundColor = "YP Black"
    static let imageViewTopMargin: CGFloat = 32
    static let leadingTrailingMargin: CGFloat = 16
    static let margin8: CGFloat = 8
    static let imageViewSize: CGFloat = 70
    static let logoutButtonTrailingMargin: CGFloat = -20
    static let fontSize23: CGFloat = 23
    static let fontSize13: CGFloat = 13
    static let placeholderImageName = "person.circle.fill"
    static let logoutButtonImageSystemName = "ipad.and.arrow.forward"
    static let loginLabelDefaultText = "@неизвестный"
    static let usernameLabelDefaultText = "Имя не указано"
    static let descriptionLabelDefaultText = "Описание отсутствует"
    static let alertTitle = "Пока, пока!"
    static let alertMessage = "Уверены, что хотите выйти?"
}

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    
    func updateProfile(with profile: Profile)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    // MARK: - IBOutlets
    private let avatarImageView = UIImageView()
    private let logoutButton = UIButton(type: .system)
    private let usernameLabel = UILabel()
    private let loginLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Public properties
    var presenter: ProfilePresenterProtocol?
    
    // MARK: - Private properties
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter?.getProfile()
        setupImageServiceObserver()
        updateAvatar()
    }
    
    // MARK: - Private methods
    private func setupViews() {
        view.backgroundColor = UIColor(named: Constants.backgroundColor)
        configureImageView()
        configureLogoutButton()
        configureUsernameLabel()
        configureLoginLabel()
        configureDescriptionLabel()
    }
    
    func updateProfile(with profile: Profile) {
        usernameLabel.text =
        profile.name.isEmpty
        ? Constants.usernameLabelDefaultText : profile.name
        loginLabel.text =
        profile.loginName.isEmpty
        ? Constants.loginLabelDefaultText : profile.loginName
        descriptionLabel.text =
        (profile.bio?.isEmpty ?? true)
        ? Constants.descriptionLabelDefaultText : profile.bio
    }
    
    private func setupImageServiceObserver() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageServiceConstants.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            }
    }
    
    private func updateAvatar() {
        guard let url = presenter?.getProfileAvatarURL() else {
            return
        }
        
        let placeholderImage = UIImage(
            systemName: Constants.placeholderImageName
        )
        
        let processor = RoundCornerImageProcessor(cornerRadius: Constants.imageViewSize / 2)
        
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh,
            ]
        ) { result in
            
            switch result {
            case .success(let value):
                print("Картинка: \(value.image)")
                print("Тип кэша: \(value.cacheType)")
                print("Источник: \(value.source)")
            case .failure:
                Logger.shared.log(method: "updateAvatar", error: "Error downloading user avatar")
            }
        }
    }
    
    private func configureImageView() {
        let profileImage = UIImage(systemName: Constants.placeholderImageName)?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(
                UIImage.SymbolConfiguration(
                    pointSize: 70,
                    weight: .regular,
                    scale: .large
                )
            )
        avatarImageView.image = profileImage
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(avatarImageView)
        
        avatarImageView.leadingAnchor
            .constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constants.leadingTrailingMargin
            ).isActive = true
        avatarImageView.topAnchor
            .constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.imageViewTopMargin
            ).isActive = true
        avatarImageView.widthAnchor
            .constraint(
                equalToConstant: Constants.imageViewSize
            ).isActive = true
        avatarImageView.heightAnchor
            .constraint(
                equalToConstant: Constants.imageViewSize
            ).isActive = true
    }
    
    private func configureLogoutButton() {
        let logoutButtonImage =
        UIImage(systemName: Constants.logoutButtonImageSystemName)
        ?? UIImage()
        let logoutButtonAction = UIAction { [weak self] action in
            guard let self else { return }
            showLogoutAlert()
        }
        
        logoutButton.setImage(logoutButtonImage, for: .normal)
        logoutButton.tintColor = .ypRed
        logoutButton.addAction(logoutButtonAction, for: .touchUpInside)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.accessibilityIdentifier = AccessibilityIdentifiers.logoutButtonIdentifier
        
        view.addSubview(logoutButton)
        
        logoutButton.trailingAnchor
            .constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constants.logoutButtonTrailingMargin
            ).isActive = true
        logoutButton.centerYAnchor
            .constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
    }
    
    private func configureUsernameLabel() {
        usernameLabel.font = UIFont.systemFont(ofSize: Constants.fontSize23, weight: .bold)
        usernameLabel.textColor = .ypWhite
        usernameLabel.text = Constants.usernameLabelDefaultText
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(usernameLabel)
        usernameLabel.leadingAnchor
            .constraint(
                equalTo: avatarImageView.leadingAnchor
            ).isActive = true
        usernameLabel.topAnchor
            .constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: Constants.margin8
            ).isActive = true
    }
    
    private func configureLoginLabel() {
        loginLabel.font = UIFont.systemFont(ofSize: Constants.fontSize13)
        loginLabel.textColor = .ypGray
        loginLabel.text = Constants.loginLabelDefaultText
        
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginLabel)
        loginLabel.leadingAnchor
            .constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        loginLabel.topAnchor
            .constraint(
                equalTo: usernameLabel.bottomAnchor,
                constant: Constants.margin8
            ).isActive = true
    }
    
    private func configureDescriptionLabel() {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.fontSize13)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.text = Constants.descriptionLabelDefaultText
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor
            .constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        descriptionLabel.topAnchor
            .constraint(
                equalTo: loginLabel.bottomAnchor,
                constant: Constants.margin8
            ).isActive = true
    }
    
    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: Constants.alertTitle,
            message: Constants.alertMessage,
            preferredStyle: .alert
        )

        alert.view.accessibilityIdentifier = AccessibilityIdentifiers.logoutAlertIdentifier
        
        let noAction = UIAlertAction(
            title: "Нет",
            style: .default
        )
        
        let yesAction = UIAlertAction(
            title: "Да",
            style: .default
        ) { [weak self] _ in
            guard let self else { return }
            logoutAndNavigateToSplashViewController()
        }
        
        yesAction.accessibilityIdentifier = AccessibilityIdentifiers.logoutAlertYesButtonIdentifier
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func logoutAndNavigateToSplashViewController() {
        presenter?.logout()
        
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })
        else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let splashViewController = SplashViewController()
        
        window.rootViewController = splashViewController
    }
    
}
