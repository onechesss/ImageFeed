//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by oneche$$$ on 03.04.2025.
//

import UIKit

class ProfileViewController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = setUpProfilePicture()
        let nameLabel = setUpNameLabel(imageView: imageView)
        let loginNameLabel = setUpLoginNameLabel(nameLabel: nameLabel)
        let descriptionLabel = setUpDescriptionLabel(loginNameLabel: loginNameLabel)
        let logoutButton = setUpLogoutButton()
    }
    
    private func setUpProfilePicture() -> UIImageView
    {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.image = UIImage(named: "avatar")
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        return imageView
    }
    
    private func setUpNameLabel(imageView: UIImageView) -> UILabel
    {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.font = .systemFont(ofSize: 23, weight: .bold)
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        return nameLabel
    }
    
    private func setUpLoginNameLabel(nameLabel: UILabel) -> UILabel
    {
        let loginNameLabel = UILabel()
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        loginNameLabel.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        loginNameLabel.text = "@ekaterina_nov"
        return loginNameLabel
    }
    
    private func setUpDescriptionLabel(loginNameLabel: UILabel) -> UILabel
    {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        return descriptionLabel
    }
    
    private func setUpLogoutButton() -> UIButton
    {
        let logoutButton = UIButton()
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.setImage(UIImage(named: "logout_button"), for: .normal)
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        return logoutButton
    }
}
