//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by oneche$$$ on 03.04.2025.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateAvatar(url: URL)
    func setProfileInfo(profile: Profile)
}



final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let loginNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let logoutButton = UIButton()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    var presenter: ProfilePresenterProtocol?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        presenter = ProfilePresenter()
        presenter?.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad()
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                presenter?.updateAvatar()
            }
        presenter?.updateAvatar()
    }

    func updateAvatar(url: URL) {
        imageView.kf.setImage(with: url, options: [.processor(RoundCornerImageProcessor.init(cornerRadius: 61))])
    }
    
    func setProfileInfo(profile: Profile) {
        nameLabel.text = profile.name
        descriptionLabel.text = profile.bio
        loginNameLabel.text = profile.loginName
    }
    
    @objc private func logoutButtonClicked() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default) { _ in
            ProfileLogoutService.shared.logout()
            let splashVC = SplashViewController()
            splashVC.modalPresentationStyle = .fullScreen
            self.present(splashVC, animated: true)
        })
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: setup view
extension ProfileViewController {
    private func setupView() {
        setUpProfilePicture(imageView: imageView)
        setUpNameLabel(nameLabel: nameLabel, imageView: imageView)
        setUpLoginNameLabel(loginNameLabel: loginNameLabel, nameLabel: nameLabel)
        setUpDescriptionLabel(descriptionLabel: descriptionLabel, loginNameLabel: loginNameLabel)
        setUpLogoutButton(logoutButton: logoutButton)
        setupBackgroundColor(vc: self)
    }
    
    private func setUpProfilePicture(imageView: UIImageView)
    {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
    }
    
    private func setUpNameLabel(nameLabel: UILabel, imageView: UIImageView)
    {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.textColor = .white
    }
    
    private func setUpLoginNameLabel(loginNameLabel: UILabel, nameLabel: UILabel)
    {
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
    }
    
    private func setUpDescriptionLabel(descriptionLabel: UILabel, loginNameLabel: UILabel)
    {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    }
    
    private func setUpLogoutButton(logoutButton: UIButton)
    {
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.setImage(UIImage(named: "logout_button"), for: .normal)
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        logoutButton.addTarget(self, action: #selector(logoutButtonClicked), for: .touchUpInside)
        logoutButton.accessibilityIdentifier = "logout button"
    }
    
    private func setupBackgroundColor(vc: UIViewController) {
        vc.view.backgroundColor = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 1)
    }
}
